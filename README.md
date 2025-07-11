# SeatSurfer: A Database-Centric Workplace Seat Management System

## 🎓 Bachelor’s Thesis Project – Universitatea Babeș-Bolyai  
**Program:** Mathematics and Computer Science (English)  
**Faculty:** Faculty of Mathematics and Computer Science  
**Author:** Prodan Radu-Matei  
**Supervisor:** Lecturer PhD Emilia-Loredana Pop  
**Academic Year:** 2024–2025

---

## 🗂️ Project Overview

**SeatSurfer** is a full-stack intelligent seat booking system designed for hybrid workplaces. The application enables employees to reserve seats in shared office environments while giving administrators complete control over floor layouts and usage statistics.

The system supports:
- Real-time seat availability
- Custom floor configuration
- Intelligent seat suggestions using AI
- Occupancy reporting and statistics
- Secure user management

---

## 🧾 Abstracts

### 🎓 Bachelor’s Thesis Abstract

The emergence of hybrid work models has led to a growing need for intelligent seat management in shared office spaces. This thesis presents **SeatSurfer**, a database-centric system designed to handle real-time seat reservations, optimize space usage, and increase user autonomy. Built with a modern full-stack architecture (Flutter frontend, Spring Boot backend, PostgreSQL), the system also incorporates a machine learning microservice for personalized seat suggestions. The thesis includes a comprehensive literature review, system design documentation, implementation details, and a simulation of 200 users to evaluate performance and scalability. The project demonstrates how database systems, REST APIs, and AI can be integrated to build efficient and user-friendly smart workplace applications.

*Declaration of Originality: This thesis is the author’s original work and complies with the academic integrity regulations of the Universitatea Babeș-Bolyai.*

---

### 📰 Conference Article Abstract

This paper proposes a new architecture for intelligent workplace booking systems in hybrid environments. We present **SeatSurfer**, a full-stack application that integrates a personalized AI seat suggestion engine, administrative layout control, and real-time booking management. The system is designed to be scalable, user-centric, and easily deployable in small to medium enterprises. By combining a modular software stack (Flutter, Spring Boot, Python ML microservice) with adaptive floor plan support and data-driven occupancy analytics, SeatSurfer fills a gap in current workplace management solutions. The article discusses the system’s motivation, design, architecture, and implementation, and outlines its contributions to the field of smart office applications.

---

## 📎 Repository Contents

- `frontend/` – Flutter-based cross-platform mobile app for users and administrators  
- `backend/` – Spring Boot REST API for authentication, booking, layout and statistics  
- `ai_service/` – Python microservice for machine learning seat recommendations  
- `thesis/` – LaTeX source code of the full Bachelor’s thesis  
- `conference_article/` – IEEE-style academic article (6–8 pages)  
- `presentation/` – Thesis defense slides and full speaker notes  

---

## 🧠 AI Component

The AI microservice suggests seats based on:
- Past user behavior
- Seat preferences (window, quiet area, etc.)
- Proximity to previously booked seats
- Popularity and occupancy trends

The model is trained on historical data and exposed through a REST API. Suggestions are ranked and customizable.

---

## 🧪 Technical Stack

- **Frontend:** Flutter, Dart  
- **Backend:** Java, Spring Boot, PostgreSQL  
- **AI Service:** Python (scikit-learn, Flask)  
- **Other Tools:** Docker, GitHub, LaTeX, draw.io  

---

## 📖 Citation

If you reference this work, please cite as:
"Prodan, Radu-Matei. SeatSurfer: A Database-Centric Seat Management System. Bachelor’s Thesis, Universitatea Babeș-Bolyai, 2025"

---

## 📬 Contact

For inquiries or collaboration, please contact:  
**Email:** mateiprodan1@gmail.com  
**LinkedIn:** https://www.linkedin.com/in/matei-prodan-7624341a4/

---

## 🔐 License

This project is licensed under the MIT License. See `LICENSE` for details.
