import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Targets for both login and signup forms
  static targets = ["firstname", "lastname", "username", "email", "password", "passwordConfirmation"]

  connect() {
    console.log("Form validation controller connected")
  }

  validate(event) {
    let isValid = true
    
    // Validate First Name (only if exists - signup form)
    if (this.hasFirstnameTarget) {
      const firstname = this.firstnameTarget.value.trim()
      if (firstname === "") {
        this.showError(this.firstnameTarget, "First name is required")
        isValid = false
      } else if (firstname.length < 2) {
        this.showError(this.firstnameTarget, "First name must be at least 2 characters")
        isValid = false
      } else {
        this.clearError(this.firstnameTarget)
      }
    }
    
    // Validate Last Name (only if exists - signup form)
    if (this.hasLastnameTarget) {
      const lastname = this.lastnameTarget.value.trim()
      if (lastname === "") {
        this.showError(this.lastnameTarget, "Last name is required")
        isValid = false
      } else if (lastname.length < 2) {
        this.showError(this.lastnameTarget, "Last name must be at least 2 characters")
        isValid = false
      } else {
        this.clearError(this.lastnameTarget)
      }
    }
    
    // Validate Username (only if exists - signup form)
    if (this.hasUsernameTarget) {
      const username = this.usernameTarget.value.trim()
      if (username === "") {
        this.showError(this.usernameTarget, "Username is required")
        isValid = false
      } else if (username.length < 3) {
        this.showError(this.usernameTarget, "Username must be at least 3 characters")
        isValid = false
      } else if (!/^[a-zA-Z0-9]+$/.test(username)) {
        this.showError(this.usernameTarget, "Username can only contain letters and numbers")
        isValid = false
      } else {
        this.clearError(this.usernameTarget)
      }
    }
    
    // Validate Email (both forms)
    // For login form: accept email OR username
    // For signup form: require email format only
    if (this.hasEmailTarget) {
      const email = this.emailTarget.value.trim()
      if (email === "") {
        this.showError(this.emailTarget, "Email is required")
        isValid = false
      } else {
        // If this is a login form (no username target), accept email OR username
        // If this is a signup form (has username target), require email format
        const isLoginForm = !this.hasUsernameTarget
        if (isLoginForm) {
          // Accept either email format or username format (alphanumeric, min 3 chars)
          if (!this.isValidEmail(email) && !this.isValidUsername(email)) {
            this.showError(this.emailTarget, "Please enter a valid email address or username")
            isValid = false
          } else {
            this.clearError(this.emailTarget)
          }
        } else {
          // Signup form: require email format
          if (!this.isValidEmail(email)) {
            this.showError(this.emailTarget, "Please enter a valid email address")
            isValid = false
          } else {
            this.clearError(this.emailTarget)
          }
        }
      }
    }
    
    // Validate Password (both forms)
    if (this.hasPasswordTarget) {
      const password = this.passwordTarget.value
      if (password === "") {
        this.showError(this.passwordTarget, "Password is required")
        isValid = false
      } else {
        // If this is a signup form (has password confirmation), apply full validation
        // If this is a login form, just check it's not empty
        const isSignupForm = this.hasPasswordConfirmationTarget
        if (isSignupForm) {
          if (!this.isValidPassword(password)) {
            this.showError(this.passwordTarget, "Password must be 8+ characters, include upper & lower case letters, a number, and a special character")
            isValid = false
          } else {
            this.clearError(this.passwordTarget)
          }
        } else {
          // Login form: just check it's not empty
          this.clearError(this.passwordTarget)
        }
      }
    }
    
    // Validate Password Confirmation (only if exists - signup form)
    if (this.hasPasswordConfirmationTarget) {
      const password = this.hasPasswordTarget ? this.passwordTarget.value : ""
      const passwordConfirmation = this.passwordConfirmationTarget.value
      
      if (passwordConfirmation === "") {
        this.showError(this.passwordConfirmationTarget, "Please confirm your password")
        isValid = false
      } else if (password !== passwordConfirmation) {
        this.showError(this.passwordConfirmationTarget, "Passwords do not match")
        isValid = false
      } else {
        this.clearError(this.passwordConfirmationTarget)
      }
    }
    
    // Prevent form submission if validation fails
    if (!isValid) {
      event.preventDefault()
    }
  }

  isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
  }

  isValidUsername(username) {
    // Username format: alphanumeric, 3-255 characters (matching User model validation)
    return /^[a-zA-Z0-9]+$/.test(username) && username.length >= 3 && username.length <= 255
  }

  isValidPassword(password) {
    // Password format matching User model validation:
    // - minimum length 8 characters
    // - must contain at least 1 digit
    // - must contain at least 1 lowercase letter
    // - must contain at least 1 uppercase letter
    // - must contain at least 1 special character
    if (password.length < 8) {
      return false
    }
    if (!/\d/.test(password)) {
      return false
    }
    if (!/[a-z]/.test(password)) {
      return false
    }
    if (!/[A-Z]/.test(password)) {
      return false
    }
    if (!/[^a-zA-Z0-9]/.test(password)) {
      return false
    }
    return true
  }

  showError(field, message) {
    this.clearError(field)
    field.classList.add("is-invalid")
    const errorDiv = document.createElement("div")
    errorDiv.className = "invalid-feedback"
    errorDiv.textContent = message
    field.parentNode.appendChild(errorDiv)
  }

  clearError(field) {
    field.classList.remove("is-invalid")
    const errorDiv = field.parentNode.querySelector(".invalid-feedback")
    if (errorDiv) {
      errorDiv.remove()
    }
  }
}