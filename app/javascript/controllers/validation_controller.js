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
      } else if (!/^[a-zA-Z0-9_]+$/.test(username)) {
        this.showError(this.usernameTarget, "Username can only contain letters, numbers, and underscores")
        isValid = false
      } else {
        this.clearError(this.usernameTarget)
      }
    }
    
    // Validate Email (both forms)
    if (this.hasEmailTarget) {
      const email = this.emailTarget.value.trim()
      if (email === "") {
        this.showError(this.emailTarget, "Email is required")
        isValid = false
      } else if (!this.isValidEmail(email)) {
        this.showError(this.emailTarget, "Please enter a valid email address")
        isValid = false
      } else {
        this.clearError(this.emailTarget)
      }
    }
    
    // Validate Password (both forms)
    if (this.hasPasswordTarget) {
      const password = this.passwordTarget.value
      if (password === "") {
        this.showError(this.passwordTarget, "Password is required")
        isValid = false
      } else if (password.length < 6) {
        this.showError(this.passwordTarget, "Password must be at least 6 characters")
        isValid = false
      } else {
        this.clearError(this.passwordTarget)
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