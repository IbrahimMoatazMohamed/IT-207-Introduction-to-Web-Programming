document.addEventListener("DOMContentLoaded", () => {
  const body = document.body;

  //logo animation
  const logo = document.querySelector(".main-header .logoo"),
    letters = Array.from(logo.children),
    letterQ = letters[4].children[0],
    leftDot = letters[3],
    rightDot = letters[5];
  letters.splice(3, 3);

  window.addEventListener("load", logoAnimation);
  logo.addEventListener("mouseenter", logoAnimation);
  logo.addEventListener("click", logoAnimation);

  function logoAnimation() {
    leftDot.style.animation =
      "logo-dots var(--dot-animation-duration) linear forwards";
    rightDot.style.animation =
      "logo-dots var(--dot-animation-duration) linear forwards";
    setTimeout(() => {
      letterQ.style.animation = "q-rotate-reverse 0.5s linear forwards";
    }, 1250);
    letterQ.style.animation = "q-rotate 0.5s linear 0.6s forwards";

    letters.forEach((letter) => {
      letter.style.animation = "move-letter 0.5s linear 0.25s forwards";
      setTimeout(() => {
        letter.style.animation = "move-letter-reverse 0.5s  linear forwards";
      }, 1950);
    });

    setTimeout(() => {
      rightDot.style.animation = "logo-right-dot-reverse 0.3s linear forwards";
    }, 1950);
    setTimeout(() => {
      leftDot.style.animation = "logo-left-dot-reverse 0.3s linear forwards";
    }, 1950);
  }

  // profile accordion menu
  function closeWhenNotMe(el, el2) {
    $(window).click((event) => {
      if (!$(event.target).is(el) && event.target !== el2) {
        el.css("opacity", 0);
        setTimeout(() => {
          el.addClass("d-none");
        }, 300);
        $(window).off("click");
        menuCounter = 0;
      }
    });
  }

  let menuCounter = 0;
  $(".main-header ul.tile-wrds li.profile").click((el) => {
    const profileMenu = $(".main-header ul.tile-wrds ul.accordion-menu");
    profileMenu.removeClass("d-none");
    profileMenu.css("opacity", 1);
    if (!menuCounter) closeWhenNotMe(profileMenu, el.target);
    menuCounter++;
  });

  //change heart in hover header
  const heartIcon = document.querySelector(".heart.fa-regular");

  heartIcon.addEventListener("mouseenter", () => {
    heartIcon.classList.remove("fa-regular");
    heartIcon.classList.add("fa-solid");
  });

  heartIcon.addEventListener("mouseleave", () => {
    heartIcon.classList.remove("fa-solid");
    heartIcon.classList.add("fa-regular");
  });

  //dark theme
  const icon = document.getElementById("switch");

  function toggleTheme() {
    if (body.classList.contains("dark-theme")) {
      body.classList.remove("dark-theme");
      localStorage.setItem("theme", "light");
    } else {
      body.classList.add("dark-theme");
      localStorage.setItem("theme", "dark");
    }
  }

  $(icon).click(toggleTheme);

  function applyThemeFromLocalStorage() {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme === "dark") {
      body.classList.add("dark-theme");
      icon.checked = true;
    } else {
      body.classList.remove("dark-theme");
      icon.checked = false;
    }
  }
  applyThemeFromLocalStorage();

  // header
  const headerMenu = document.querySelector(
    ".main-header .container button.menu"
  );
  const headerWords = document.querySelector(".main-header ul.tile-wrds");
  const globalModal = document.getElementById("globalModal");

  headerMenu.addEventListener("click", (el) => {
    if (headerWords.classList.contains("active")) {
      console.log($(el.target).closest(".tile-wrds").length);
      closeNav();
    } else {
      openNav();
    }
  });
  globalModal.addEventListener("click", () => {
    closeNav();
  });

  document.querySelectorAll(".main-header ul.tile-wrds li").forEach((icon) => {
    if (!icon.classList.contains("profile")) {
      icon.addEventListener("click", closeNav);
    }
  });

  function appearModal() {
    globalModal.classList.add("d-block");
    setTimeout(() => {
      globalModal.classList.add("active");
      body.classList.add("fix");
    }, 2);
  }

  function disappearModal() {
    globalModal.classList.remove("active");
    body.classList.remove("fix");
    setTimeout(() => {
      globalModal.classList.remove("d-block");
    }, 300);
  }

  function closeNav() {
    headerMenu.classList.remove("active");
    headerWords.classList.remove("active");
    disappearModal();

    setTimeout(() => {
      headerWords.classList.add("disappear");
    }, 300);
  }
  function openNav() {
    headerMenu.classList.add("active");
    headerWords.classList.remove("disappear");

    setTimeout(() => {
      headerWords.classList.add("active");
      appearModal();
    }, 5);
  }

  // Go Up
  const goUpBox = document.querySelector(".go-up-box");

  window.addEventListener("scroll", function () {
    if (window.scrollY > 200) {
      goUpBox.classList.add("active");
    } else {
      goUpBox.classList.remove("active");
    }
  });
  goUpBox.addEventListener("click", () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  });
  const user_id = 1;
  CartService.shoppingCartCounter(user_id, 0);
});
