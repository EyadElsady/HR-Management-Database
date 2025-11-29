
	CREATE DATABASE HR_System 
	CREATE TABLE Department (
	department_id INT IDENTITY PRIMARY KEY,
	department_name VARCHAR(100) NOT NULL,
	purpose VARCHAR(500),
	department_head_id INT NULL
	)
	CREATE TABLE Position (
	position_id INT IDENTITY PRIMARY KEY,
	position_title VARCHAR(100) NOT NULL,
	responsibilities VARCHAR(MAX),
	status VARCHAR(50)
	)
	CREATE TABLE PayGrade (
	pay_grade_id INT IDENTITY PRIMARY KEY,
	grade_name VARCHAR(50),
	min_salary DECIMAL(18,2),
	max_salary DECIMAL(18,2)
	)
	CREATE TABLE TaxForm (
	tax_form_id INT IDENTITY PRIMARY KEY,
	jurisdiction VARCHAR(100),
	validity_period VARCHAR(100),
	form_content VARCHAR(MAX)
	)
	CREATE TABLE SalaryType (
	salary_type_id INT IDENTITY PRIMARY KEY,
	type VARCHAR(50),
	payment_frequency VARCHAR(50),
	currency_code VARCHAR(10)
	)
	CREATE TABLE Contract (
	contract_id INT IDENTITY PRIMARY KEY,
	type VARCHAR(50),
	start_date DATE,
	end_date DATE,
	current_state VARCHAR(50)
	)
	CREATE TABLE Employee (
	employee_id INT IDENTITY PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	full_name AS (first_name + ' ' + last_name) PERSISTED,
	national_id VARCHAR(50),
	date_of_birth DATE,
	country_of_birth VARCHAR(100),
	phone VARCHAR(50),
	email VARCHAR(150),
	address VARCHAR(255),
	emergency_contact_name VARCHAR(100),
	emergency_contact_phone VARCHAR(50),
	relationship VARCHAR(50),
	biography VARCHAR(MAX),
	profile_image VARBINARY(MAX),
	employment_progress VARCHAR(100),
	account_status VARCHAR(50),
	employment_status VARCHAR(50),
	hire_date DATE,
	is_active BIT DEFAULT 1,
	profile_completion INT DEFAULT 0,
	department_id INT NULL,
	position_id INT NULL,
	manager_id INT NULL,
	contract_id INT NULL,
	tax_form_id INT NULL,
	salary_type_id INT NULL,
	pay_grade INT NULL
	)
	ALTER TABLE Department ADD CONSTRAINT FK_Department_Head FOREIGN KEY (department_head_id) REFERENCES Employee(employee_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (department_id) REFERENCES Department(department_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_Position FOREIGN KEY (position_id) REFERENCES Position(position_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_Manager FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_Contract FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_TaxForm FOREIGN KEY (tax_form_id) REFERENCES TaxForm(tax_form_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_SalaryType FOREIGN KEY (salary_type_id) REFERENCES SalaryType(salary_type_id)
	ALTER TABLE Employee ADD CONSTRAINT FK_Employee_PayGrade FOREIGN KEY (pay_grade) REFERENCES PayGrade(pay_grade_id)
	CREATE TABLE Skill (
	skill_id INT IDENTITY PRIMARY KEY,
	skill_name VARCHAR(100) UNIQUE,
	description VARCHAR(MAX)
	)
	CREATE TABLE Employee_Skill (
	employee_id INT,
	skill_id INT,
	proficiency_level INT,
	PRIMARY KEY (employee_id, skill_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
	)
	CREATE TABLE Verification (
	verification_id INT IDENTITY PRIMARY KEY,
	verification_type VARCHAR(100),
	issuer VARCHAR(200),
	issue_date DATE,
	expiry_period VARCHAR(50)
	)
	CREATE TABLE Employee_Verification (
	employee_id INT,
	verification_id INT,
	PRIMARY KEY (employee_id, verification_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (verification_id) REFERENCES Verification(verification_id)
	)
	CREATE TABLE Role (
	role_id INT IDENTITY PRIMARY KEY,
	role_name VARCHAR(100),
	purpose VARCHAR(200)
	)
	CREATE TABLE Employee_Role (
	employee_id INT,
	role_id INT,
	assigned_date DATE DEFAULT GETDATE(),
	PRIMARY KEY (employee_id, role_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (role_id) REFERENCES Role(role_id)
	)
	CREATE TABLE RolePermission (
	role_id INT,
	permission_name VARCHAR(200),
	allowed_action VARCHAR(200),
	PRIMARY KEY (role_id, permission_name),
	FOREIGN KEY (role_id) REFERENCES Role(role_id)
	)
	CREATE TABLE FullTimeContract (
	contract_id INT PRIMARY KEY,
	leave_entitlement DECIMAL(6,2),
	insurance_eligibility BIT,
	weekly_working_hours INT,
	FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
	)
	CREATE TABLE PartTimeContract (
	contract_id INT PRIMARY KEY,
	working_hours INT,
	hourly_rate DECIMAL(18,2),
	FOREIGN KEY (contract_id) REFERENCES Contract(contract_id)
	)
	CREATE TABLE [Leave] (
	leave_id INT IDENTITY PRIMARY KEY,
	leave_type VARCHAR(50),
	leave_description VARCHAR(MAX)
	)
	CREATE TABLE VacationLeave (
	leave_id INT PRIMARY KEY,
	carry_over_days INT,
	approving_manager INT,
	FOREIGN KEY (leave_id) REFERENCES [Leave](leave_id)
	)
	CREATE TABLE LeaveRequest (
	request_id INT IDENTITY PRIMARY KEY,
	employee_id INT,
	leave_id INT,
	justification VARCHAR(MAX),
	duration INT,
	approval_timing DATETIME NULL,
	status VARCHAR(50) DEFAULT 'Pending',
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (leave_id) REFERENCES [Leave](leave_id)
	)
	CREATE TABLE LeaveEntitlement (
	employee_id INT,
	leave_type_id INT,
	entitlement DECIMAL(6,2),
	PRIMARY KEY (employee_id, leave_type_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (leave_type_id) REFERENCES [Leave](leave_id)
	)
	CREATE TABLE LeaveDocument (
	document_id INT IDENTITY PRIMARY KEY,
	leave_request_id INT,
	file_path VARCHAR(500),
	uploaded_at DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (leave_request_id) REFERENCES LeaveRequest(request_id)
	)
	CREATE TABLE ShiftSchedule (
	shift_id INT IDENTITY PRIMARY KEY,
	name VARCHAR(100),
	type VARCHAR(50),
	start_time TIME,
	end_time TIME,
	break_duration INT,
	shift_date DATE NULL,
	status VARCHAR(50)
	)
	CREATE TABLE ShiftAssignment (
	assignment_id INT IDENTITY PRIMARY KEY,
	employee_id INT,
	shift_id INT,
	start_date DATE,
	end_date DATE,
	status VARCHAR(50),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id)
	)
	CREATE TABLE Device (
	device_id INT IDENTITY PRIMARY KEY,
	device_type VARCHAR(50),
	terminal_id VARCHAR(100),
	latitude DECIMAL(10,7) NULL,
	longitude DECIMAL(10,7) NULL,
	employee_id INT NULL,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
	)

	CREATE TABLE Exception (
	exception_id INT IDENTITY PRIMARY KEY,
	name VARCHAR(100),
	category VARCHAR(100),
	date DATE,
	status VARCHAR(50)
	)
	CREATE TABLE Attendance (
	attendance_id INT IDENTITY PRIMARY KEY,
	employee_id INT,
	shift_id INT NULL,
	entry_time DATETIME NULL,
	exit_time DATETIME NULL,
	duration INT NULL,
	login_method VARCHAR(50),
	logout_method VARCHAR(50),
	exception_id INT NULL,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (shift_id) REFERENCES ShiftSchedule(shift_id),
	FOREIGN KEY (exception_id) REFERENCES Exception(exception_id)
	)
	CREATE TABLE AttendanceLog (
	attendance_log_id INT IDENTITY PRIMARY KEY,
	attendance_id INT,
	actor INT,
	[timestamp] DATETIME DEFAULT GETDATE(),
	reason VARCHAR(500),
	FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id)
	)
	
	CREATE TABLE AttendanceSource (
	id INT IDENTITY PRIMARY KEY,
	attendance_id INT,
	device_id INT,
	source_type VARCHAR(50),
	latitude DECIMAL(10,7),
	longitude DECIMAL(10,7),
	recorded_at DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (attendance_id) REFERENCES Attendance(attendance_id),
	FOREIGN KEY (device_id) REFERENCES Device(device_id)
	)
	
	CREATE TABLE Payroll (
	payroll_id INT IDENTITY PRIMARY KEY,
	employee_id INT,
	taxes DECIMAL(18,2),
	period_start DATE,
	period_end DATE,
	base_amount DECIMAL(18,2),
	adjustments DECIMAL(18,2) DEFAULT 0,
	contributions DECIMAL(18,2) DEFAULT 0,
	actual_pay DECIMAL(18,2),
	net_salary DECIMAL(18,2),
	payment_date DATE,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
	)
	
	CREATE TABLE AllowanceDeduction (
	ad_id INT IDENTITY PRIMARY KEY,
	payroll_id INT NULL,
	employee_id INT,
	type VARCHAR(50),
	amount DECIMAL(18,2),
	currency_code VARCHAR(10),
	duration INT NULL,
	timezone VARCHAR(50) NULL,
	FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
	)
	CREATE TABLE PayrollPolicy (
	policy_id INT IDENTITY PRIMARY KEY,
	effective_date DATE,
	type VARCHAR(50),
	description VARCHAR(MAX)
	)
	CREATE TABLE Payroll_Log (
	payroll_log_id INT IDENTITY PRIMARY KEY,
	payroll_id INT,
	actor INT,
	change_date DATETIME DEFAULT GETDATE(),
	modification_type VARCHAR(100),
	FOREIGN KEY (payroll_id) REFERENCES Payroll(payroll_id)
	)
	CREATE TABLE Notification (
	notification_id INT IDENTITY PRIMARY KEY,
	message_content VARCHAR(1000),
	timestamp DATETIME DEFAULT GETDATE(),
	urgency VARCHAR(50),
	read_status BIT DEFAULT 0,
	notification_type VARCHAR(50)
	)
	CREATE TABLE Employee_Notification (
	employee_id INT,
	notification_id INT,
	delivery_status VARCHAR(50),
	delivered_at DATETIME NULL,
	PRIMARY KEY (employee_id, notification_id),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
	)
	CREATE TABLE ManagerNotes (
	note_id INT IDENTITY PRIMARY KEY,
	employee_id INT,
	manager_id INT,
	note_content VARCHAR(MAX),
	created_at DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
	)
	CREATE TABLE EmployeeHierarchy (
	employee_id INT PRIMARY KEY,
	manager_id INT,
	hierarchy_level INT,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
	)
	
	CREATE TABLE Mission (
	mission_id INT IDENTITY PRIMARY KEY,
	destination VARCHAR(200),
	start_date DATE,
	end_date DATE,
	status VARCHAR(50),
	employee_id INT,
	manager_id INT,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
	FOREIGN KEY (manager_id) REFERENCES Employee(employee_id)
	)
	
	CREATE TABLE Reimbursement (
	reimbursement_id INT IDENTITY PRIMARY KEY,
	type VARCHAR(100),
	claim_type VARCHAR(100),
	approval_date DATE NULL,
	current_status VARCHAR(50),
	employee_id INT,
	amount DECIMAL(18,2) NULL,
	FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
	)	 

USE HR_System;
GO

INSERT INTO Department (department_name, purpose, department_head_id)
VALUES 
('Human Resources', 'Manage employee relations and policies', NULL),
('Information Technology', 'Manage technology infrastructure', NULL),
('Finance', 'Manage financial operations', NULL),
('Marketing', 'Manage marketing and branding', NULL),
('Operations', 'Manage daily operations', NULL);

INSERT INTO Position (position_title, responsibilities, status)
VALUES 
('CEO', 'Chief Executive Officer - Overall company leadership', 'Active'),
('HR Manager', 'Manage HR department and employee relations', 'Active'),
('IT Manager', 'Manage IT infrastructure and systems', 'Active'),
('Software Developer', 'Develop and maintain software systems', 'Active'),
('Accountant', 'Manage financial records and reporting', 'Active'),
('Marketing Specialist', 'Execute marketing campaigns', 'Active'),
('System Administrator', 'Manage system access and configurations', 'Active'),
('Payroll Officer', 'Process payroll and benefits', 'Active'),
('Operations Manager', 'Oversee daily operations', 'Active'),
('Team Lead', 'Lead and manage team members', 'Active');

INSERT INTO PayGrade (grade_name, min_salary, max_salary)
VALUES 
('Grade A', 30000.00, 50000.00),
('Grade B', 50000.00, 80000.00),
('Grade C', 80000.00, 120000.00),
('Grade D', 120000.00, 180000.00),
('Grade E', 180000.00, 250000.00);

INSERT INTO TaxForm (jurisdiction, validity_period, form_content)
VALUES 
('Egypt', '2025-2026', 'Standard Egyptian tax form'),
('USA', '2025', 'US W-4 form'),
('UK', '2025-2026', 'UK P45 form');

INSERT INTO SalaryType (type, payment_frequency, currency_code)
VALUES 
('Monthly', 'Monthly', 'EGP'),
('Hourly', 'Weekly', 'EGP'),
('Daily', 'Daily', 'EGP'),
('Annual', 'Yearly', 'USD');

INSERT INTO Contract (type, start_date, end_date, current_state)
VALUES 
('Full-Time', '2024-01-01', '2025-12-31', 'Active'),
('Part-Time', '2024-06-01', '2025-06-01', 'Active'),
('Full-Time', '2023-03-15', '2025-03-15', 'Active'),
('Contract', '2024-09-01', '2025-09-01', 'Active'),
('Full-Time', '2024-02-01', '2026-02-01', 'Active');

INSERT INTO Employee (first_name, last_name, national_id, date_of_birth, country_of_birth, 
    phone, email, address, emergency_contact_name, emergency_contact_phone, relationship,
    biography, employment_progress, account_status, employment_status, hire_date, 
    is_active, profile_completion, department_id, position_id, manager_id, 
    contract_id, tax_form_id, salary_type_id, pay_grade)
VALUES 
('Ahmed', 'Hassan', '29501011234567', '1995-01-01', 'Egypt', 
    '+201234567890', 'ahmed.hassan@company.com', '123 Cairo St, Cairo', 
    'Fatma Hassan', '+201987654321', 'Spouse',
    'Experienced HR professional', 'Onboarded', 'Active', 'Active', '2024-01-01',
    1, 100, 1, 2, NULL, 1, 1, 1, 3),

('Sara', 'Mohamed', '29601021234568', '1996-01-02', 'Egypt',
    '+201234567891', 'sara.mohamed@company.com', '456 Giza St, Giza',
    'Ali Mohamed', '+201987654322', 'Father',
    'Skilled IT professional', 'Onboarded', 'Active', 'Active', '2024-02-01',
    1, 100, 2, 3, NULL, 2, 1, 1, 3),

('Omar', 'Ali', '29701031234569', '1997-01-03', 'Egypt',
    '+201234567892', 'omar.ali@company.com', '789 Alexandria St, Alexandria',
    'Mona Ali', '+201987654323', 'Mother',
    'Creative developer', 'Onboarded', 'Active', 'Active', '2023-03-15',
    1, 95, 2, 4, 2, 3, 1, 1, 2),

('Nour', 'Ibrahim', '29801041234570', '1998-01-04', 'Egypt',
    '+201234567893', 'nour.ibrahim@company.com', '321 Mansoura St, Mansoura',
    'Hassan Ibrahim', '+201987654324', 'Father',
    'Detail-oriented accountant', 'Onboarded', 'Active', 'Active', '2024-09-01',
    1, 90, 3, 5, NULL, 4, 1, 1, 2),

('Layla', 'Khalil', '29901051234571', '1999-01-05', 'Egypt',
    '+201234567894', 'layla.khalil@company.com', '654 Tanta St, Tanta',
    'Amira Khalil', '+201987654325', 'Sister',
    'Marketing enthusiast', 'Onboarded', 'Active', 'Active', '2024-02-01',
    1, 85, 4, 6, NULL, 5, 1, 1, 2),

('Khaled', 'Mahmoud', '29001061234572', '1990-01-06', 'Egypt',
    '+201234567895', 'khaled.mahmoud@company.com', '987 Aswan St, Aswan',
    'Hoda Mahmoud', '+201987654326', 'Spouse',
    'System expert', 'Onboarded', 'Active', 'Active', '2024-01-15',
    1, 100, 2, 7, 2, 1, 1, 1, 3),

('Yasmin', 'Sayed', '29101071234573', '1991-01-07', 'Egypt',
    '+201234567896', 'yasmin.sayed@company.com', '147 Luxor St, Luxor',
    'Karim Sayed', '+201987654327', 'Brother',
    'Payroll specialist', 'Onboarded', 'Active', 'Active', '2024-03-01',
    1, 100, 1, 8, 1, 1, 1, 1, 2),

('Tarek', 'Farid', '29201081234574', '1992-01-08', 'Egypt',
    '+201234567897', 'tarek.farid@company.com', '258 Ismailia St, Ismailia',
    'Salma Farid', '+201987654328', 'Spouse',
    'Operations leader', 'Onboarded', 'Active', 'Active', '2024-04-01',
    1, 100, 5, 9, NULL, 1, 1, 1, 4);
UPDATE Department SET department_head_id = 1 WHERE department_id = 1;
UPDATE Department SET department_head_id = 2 WHERE department_id = 2;
UPDATE Department SET department_head_id = 4 WHERE department_id = 3;
UPDATE Department SET department_head_id = 5 WHERE department_id = 4;
UPDATE Department SET department_head_id = 8 WHERE department_id = 5;

INSERT INTO Skill (skill_name, description)
VALUES 
('SQL', 'Database management and querying'),
('Python', 'Programming language'),
('Project Management', 'Managing projects and teams'),
('Communication', 'Effective communication skills'),
('Leadership', 'Team leadership abilities'),
('Accounting', 'Financial accounting knowledge'),
('Marketing', 'Marketing strategies and execution');

INSERT INTO Employee_Skill (employee_id, skill_id, proficiency_level)
VALUES 
(2, 1, 8), (2, 2, 7),
(3, 1, 9), (3, 2, 9),
(4, 6, 8),
(5, 7, 7),
(6, 1, 9), (6, 5, 8);
 
INSERT INTO Role (role_name, purpose)
VALUES 
('System Admin', 'Full system administration rights'),
('HR Admin', 'HR management functions'),
('Payroll Officer', 'Payroll processing'),
('Manager', 'Team management'),
('Employee', 'Standard employee access');

INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
VALUES 
(6, 1, '2024-01-15'), -- System Admin
(1, 2, '2024-01-01'), -- HR Admin
(7, 3, '2024-03-01'), -- Payroll Officer
(2, 4, '2024-02-01'), -- Manager
(8, 4, '2024-04-01'), -- Manager
(3, 5, '2023-03-15'), -- Employee
(4, 5, '2024-09-01'), -- Employee
(5, 5, '2024-02-01'); -- Employee

INSERT INTO FullTimeContract (contract_id, leave_entitlement, insurance_eligibility, weekly_working_hours)
VALUES 
(1, 21.00, 1, 40),
(3, 21.00, 1, 40),
(5, 21.00, 1, 40);

INSERT INTO PartTimeContract (contract_id, working_hours, hourly_rate)
VALUES 
(2, 20, 50.00),
(4, 30, 75.00);
 
INSERT INTO [Leave] (leave_type, leave_description)
VALUES 
('Annual Leave', 'Standard annual vacation leave'),
('Sick Leave', 'Medical leave for illness'),
('Emergency Leave', 'Emergency situations'),
('Maternity Leave', 'Maternity leave for mothers'),
('Paternity Leave', 'Paternity leave for fathers');
 
INSERT INTO VacationLeave (leave_id, carry_over_days, approving_manager)
VALUES 
(1, 5, 1);
 
INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
VALUES 
(1, 1, 21.00), (1, 2, 10.00),
(2, 1, 21.00), (2, 2, 10.00),
(3, 1, 21.00), (3, 2, 10.00),
(4, 1, 21.00), (4, 2, 10.00),
(5, 1, 21.00), (5, 2, 10.00),
(6, 1, 21.00), (6, 2, 10.00),
(7, 1, 21.00), (7, 2, 10.00),
(8, 1, 21.00), (8, 2, 10.00);
INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status)
VALUES 
('Morning Shift', 'Normal', '08:00:00', '16:00:00', 60, NULL, 'Active'),
('Evening Shift', 'Normal', '14:00:00', '22:00:00', 60, NULL, 'Active'),
('Night Shift', 'Overnight', '22:00:00', '06:00:00', 60, NULL, 'Active'),
('Flexible Shift', 'Flex', '09:00:00', '17:00:00', 60, NULL, 'Active');
 
INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
VALUES 
(1, 1, '2024-01-01', '2025-12-31', 'Approved'),
(2, 1, '2024-02-01', '2025-12-31', 'Approved'),
(3, 4, '2023-03-15', '2025-12-31', 'Approved'),
(4, 1, '2024-09-01', '2025-12-31', 'Approved'),
(5, 1, '2024-02-01', '2025-12-31', 'Approved'),
(6, 1, '2024-01-15', '2025-12-31', 'Approved'),
(7, 1, '2024-03-01', '2025-12-31', 'Approved'),
(8, 1, '2024-04-01', '2025-12-31', 'Approved');

INSERT INTO Device (device_type, terminal_id, latitude, longitude, employee_id)
VALUES 
('Biometric', 'TERM001', 30.0444, 31.2357, NULL),
('Biometric', 'TERM002', 30.0131, 31.2089, NULL),
('GPS', 'GPS001', NULL, NULL, NULL);

INSERT INTO Exception (name, category, date, status)
VALUES 
('Public Holiday', 'Holiday', '2025-01-25', 'Active'),
('System Maintenance', 'Technical', '2025-02-15', 'Active');

INSERT INTO PayrollPolicy (effective_date, type, description)
VALUES 
('2024-01-01', 'Overtime', 'Overtime rate 1.5x for weekdays, 2x for weekends'),
('2024-01-01', 'Bonus', 'Annual performance bonus policy'),
('2024-01-01', 'Deduction', 'Standard deduction rules');

INSERT INTO Notification (message_content, urgency, notification_type)
VALUES 
('Welcome to the HR System', 'Low', 'System'),
('Your leave request has been approved', 'Medium', 'Leave'),
('Payroll processed successfully', 'High', 'Payroll');

INSERT INTO EmployeeHierarchy (employee_id, manager_id, hierarchy_level)
VALUES 
(1, NULL, 1),
(2, NULL, 1),
(3, 2, 2),
(4, NULL, 1),
(5, NULL, 1),
(6, 2, 2),
(7, 1, 2),
(8, NULL, 1);

PRINT 'Sample data inserted successfully!';
GO
DROP PROCEDURE IF EXISTS ViewEmployeeInfo;
DROP PROCEDURE IF EXISTS AddEmployee;
DROP PROCEDURE IF EXISTS UpdateEmployeeInfo;
DROP PROCEDURE IF EXISTS AssignRole;
DROP PROCEDURE IF EXISTS GetDepartmentEmployeeStats;
DROP PROCEDURE IF EXISTS ReassignManager;
DROP PROCEDURE IF EXISTS ReassignHierarchy;
DROP PROCEDURE IF EXISTS NotifyStructureChange;
DROP PROCEDURE IF EXISTS ViewOrgHierarchy;
DROP PROCEDURE IF EXISTS AssignShiftToEmployee;
DROP PROCEDURE IF EXISTS UpdateShiftStatus;
DROP PROCEDURE IF EXISTS AssignShiftToDepartment;
DROP PROCEDURE IF EXISTS AssignCustomShift;
DROP PROCEDURE IF EXISTS ConfigureSplitShift;
DROP PROCEDURE IF EXISTS EnableFirstInLastOut;
DROP PROCEDURE IF EXISTS TagAttendanceSource;
DROP PROCEDURE IF EXISTS SyncOfflineAttendance;
DROP PROCEDURE IF EXISTS LogAttendanceEdit;
DROP PROCEDURE IF EXISTS ApplyHolidayOverrides;
DROP PROCEDURE IF EXISTS ManageUserAccounts;

 GO
CREATE PROCEDURE ViewEmployeeInfo
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
    BEGIN
        RAISERROR('Employee with ID %d does not exist.', 16, 1, @EmployeeID);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
    BEGIN
        RAISERROR('Employee with ID %d is not active.', 16, 1, @EmployeeID);
        RETURN;
    END
    
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.full_name,
        e.national_id,
        e.date_of_birth,
        e.country_of_birth,
        e.phone,
        e.email,
        e.address,
        e.emergency_contact_name,
        e.emergency_contact_phone,
        e.relationship,
        e.biography,
        e.employment_progress,
        e.account_status,
        e.employment_status,
        e.hire_date,
        e.is_active,
        e.profile_completion,
        d.department_name,
        p.position_title,
        m.first_name + ' ' + m.last_name AS manager_name,
        c.type AS contract_type,
        st.type AS salary_type,
        pg.grade_name AS pay_grade
    FROM Employee e
    LEFT JOIN Department d ON e.department_id = d.department_id
    LEFT JOIN Position p ON e.position_id = p.position_id
    LEFT JOIN Employee m ON e.manager_id = m.employee_id
    LEFT JOIN Contract c ON e.contract_id = c.contract_id
    LEFT JOIN SalaryType st ON e.salary_type_id = st.salary_type_id
    LEFT JOIN PayGrade pg ON e.pay_grade = pg.pay_grade_id
    WHERE e.employee_id = @EmployeeID;
END
GO

CREATE PROCEDURE AddEmployee
    @FullName VARCHAR(200),
    @NationalID VARCHAR(50),
    @DateOfBirth DATE,
    @CountryOfBirth VARCHAR(100),
    @Phone VARCHAR(50),
    @Email VARCHAR(100),
    @Address VARCHAR(255),
    @EmergencyContactName VARCHAR(100),
    @EmergencyContactPhone VARCHAR(50),
    @Relationship VARCHAR(50),
    @Biography VARCHAR(MAX),
    @EmploymentProgress VARCHAR(100),
    @AccountStatus VARCHAR(50),
    @EmploymentStatus VARCHAR(50),
    @HireDate DATE,
    @IsActive BIT,
    @ProfileCompletion INT,
    @DepartmentID INT,
    @PositionID INT,
    @ManagerID INT,
    @ContractID INT,
    @TaxFormID INT,
    @SalaryTypeID INT,
    @PayGrade VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF @Email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('Invalid email format.', 16, 1);
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Employee WHERE national_id = @NationalID)
        BEGIN
            RAISERROR('Employee with National ID %s already exists.', 16, 1, @NationalID);
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Employee WHERE email = @Email)
        BEGIN
            RAISERROR('Employee with email %s already exists.', 16, 1, @Email);
            RETURN;
        END
        
        IF @DepartmentID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department with ID %d does not exist.', 16, 1, @DepartmentID);
            RETURN;
        END
 
        IF @PositionID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Position WHERE position_id = @PositionID)
        BEGIN
            RAISERROR('Position with ID %d does not exist.', 16, 1, @PositionID);
            RETURN;
        END
 
        IF @ManagerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND is_active = 1)
        BEGIN
            RAISERROR('Manager with ID %d does not exist or is not active.', 16, 1, @ManagerID);
            RETURN;
        END
         
        IF @DateOfBirth > DATEADD(YEAR, -14, GETDATE())
        BEGIN
            RAISERROR('Employee must be at least 14 years old.', 16, 1);
            RETURN;
        END
 
        IF @HireDate > CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Hire date cannot be in the future.', 16, 1);
            RETURN;
        END
         
        DECLARE @FirstName VARCHAR(100), @LastName VARCHAR(100);
        SET @FirstName = LEFT(@FullName, CHARINDEX(' ', @FullName) - 1);
        SET @LastName = SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName));
 
        INSERT INTO Employee (
            first_name, last_name, national_id, date_of_birth, country_of_birth,
            phone, email, address, emergency_contact_name, emergency_contact_phone,
            relationship, biography, employment_progress, account_status, employment_status,
            hire_date, is_active, profile_completion, department_id, position_id,
            manager_id, contract_id, tax_form_id, salary_type_id, pay_grade
        )
        VALUES (
            @FirstName, @LastName, @NationalID, @DateOfBirth, @CountryOfBirth,
            @Phone, @Email, @Address, @EmergencyContactName, @EmergencyContactPhone,
            @Relationship, @Biography, @EmploymentProgress, @AccountStatus, @EmploymentStatus,
            @HireDate, @IsActive, @ProfileCompletion, @DepartmentID, @PositionID,
            @ManagerID, @ContractID, @TaxFormID, @SalaryTypeID, @PayGrade
        );
        
        DECLARE @NewEmployeeID INT = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Employee added successfully' AS Message,
            @NewEmployeeID AS NewEmployeeID;
            
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE UpdateEmployeeInfo
    @EmployeeID INT,
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @Address VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee with ID %d does not exist.', 16, 1, @EmployeeID);
            RETURN;
        END
         
        IF @Email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('Invalid email format.', 16, 1);
            RETURN;
        END
 
        IF EXISTS (SELECT 1 FROM Employee WHERE email = @Email AND employee_id != @EmployeeID)
        BEGIN
            RAISERROR('Email %s is already in use by another employee.', 16, 1, @Email);
            RETURN;
        END
        
        UPDATE Employee 
        SET 
            email = @Email,
            phone = @Phone,
            address = @Address
        WHERE employee_id = @EmployeeID;
        
        SELECT 'Employee information updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE AssignRole
    @EmployeeID INT,
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Role WHERE role_id = @RoleID)
        BEGIN
            RAISERROR('Role with ID %d does not exist.', 16, 1, @RoleID);
            RETURN;
        END
         
        IF EXISTS (SELECT 1 FROM Employee_Role WHERE employee_id = @EmployeeID AND role_id = @RoleID)
        BEGIN
            RAISERROR('Employee already has role with ID %d.', 16, 1, @RoleID);
            RETURN;
        END
        
        INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
        VALUES (@EmployeeID, @RoleID, GETDATE());
        
        COMMIT TRANSACTION;
        
        SELECT 'Role assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE GetDepartmentEmployeeStats
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        d.department_name AS Department,
        COUNT(e.employee_id) AS EmployeeCount
    FROM Department d
    LEFT JOIN Employee e ON d.department_id = e.department_id AND e.is_active = 1
    GROUP BY d.department_id, d.department_name
    ORDER BY EmployeeCount DESC;
END
GO
 
CREATE PROCEDURE ReassignManager
    @EmployeeID INT,
    @NewManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @NewManagerID AND is_active = 1)
        BEGIN
            RAISERROR('New manager with ID %d does not exist or is not active.', 16, 1, @NewManagerID);
            RETURN;
        END
 
        IF @EmployeeID = @NewManagerID
        BEGIN
            RAISERROR('Employee cannot be their own manager.', 16, 1);
            RETURN;
        END
 
        DECLARE @CurrentManagerID INT = @NewManagerID;
        WHILE @CurrentManagerID IS NOT NULL
        BEGIN
            IF @CurrentManagerID = @EmployeeID
            BEGIN
                RAISERROR('Circular manager hierarchy detected.', 16, 1);
                RETURN;
            END
            SELECT @CurrentManagerID = manager_id FROM Employee WHERE employee_id = @CurrentManagerID;
        END
        
        UPDATE Employee 
        SET manager_id = @NewManagerID 
        WHERE employee_id = @EmployeeID;
 
        IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EmployeeHierarchy')
        BEGIN
 
            UPDATE EmployeeHierarchy 
            SET manager_id = @NewManagerID 
            WHERE employee_id = @EmployeeID;
        END
        
        COMMIT TRANSACTION;
        
        SELECT 'Manager reassigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ReassignHierarchy
    @EmployeeID INT,
    @NewDepartmentID INT,
    @NewManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @NewDepartmentID)
        BEGIN
            RAISERROR('Department with ID %d does not exist.', 16, 1, @NewDepartmentID);
            RETURN;
        END
 
        IF @NewManagerID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @NewManagerID AND is_active = 1)
        BEGIN
            RAISERROR('New manager with ID %d does not exist or is not active.', 16, 1, @NewManagerID);
            RETURN;
        END
 
        IF @EmployeeID = @NewManagerID
        BEGIN
            RAISERROR('Employee cannot be their own manager.', 16, 1);
            RETURN;
        END
        
        UPDATE Employee 
        SET 
            department_id = @NewDepartmentID,
            manager_id = @NewManagerID
        WHERE employee_id = @EmployeeID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Employee hierarchy reassigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

 
CREATE PROCEDURE NotifyStructureChange
    @AffectedEmployees VARCHAR(500), 
    @Message VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
   
        IF @Message IS NULL OR LTRIM(RTRIM(@Message)) = ''
        BEGIN
            RAISERROR('Notification message cannot be empty.', 16, 1);
            RETURN;
        END
        
  
        IF @AffectedEmployees IS NULL OR LTRIM(RTRIM(@AffectedEmployees)) = ''
        BEGIN
            RAISERROR('No affected employees specified.', 16, 1);
            RETURN;
        END
        
        CREATE TABLE #TempEmployees (EmployeeID INT);
        
        INSERT INTO #TempEmployees (EmployeeID)
        SELECT value 
        FROM STRING_SPLIT(@AffectedEmployees, ',');
        
        IF EXISTS (
            SELECT 1 FROM #TempEmployees te 
            WHERE NOT EXISTS (SELECT 1 FROM Employee e WHERE e.employee_id = te.EmployeeID AND e.is_active = 1)
        )
        BEGIN
            RAISERROR('One or more employee IDs in the list do not exist or are not active.', 16, 1);
            RETURN;
        END
        INSERT INTO Notification (message_content, timestamp, urgency, notification_type)
        SELECT 
            @Message,
            GETDATE(),
            'High',
            'Structural Change'
        FROM #TempEmployees;
        
        DECLARE @NotificationID INT = SCOPE_IDENTITY();

        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        SELECT 
            te.EmployeeID,
            @NotificationID + (ROW_NUMBER() OVER (ORDER BY te.EmployeeID) - 1),
            'Pending'
        FROM #TempEmployees te;
        
        COMMIT TRANSACTION;
        
        SELECT 'Notifications sent successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ViewOrgHierarchy
AS
BEGIN
    SET NOCOUNT ON;
    
    WITH EmployeeHierarchy AS (
        SELECT 
            e.employee_id,
            e.first_name + ' ' + e.last_name AS employee_name,
            e.manager_id,
            NULL AS manager_name,
            d.department_name,
            p.position_title,
            1 AS hierarchy_level
        FROM Employee e
        LEFT JOIN Department d ON e.department_id = d.department_id
        LEFT JOIN Position p ON e.position_id = p.position_id
        WHERE e.manager_id IS NULL OR NOT EXISTS (
            SELECT 1 FROM Employee m 
            WHERE m.employee_id = e.manager_id AND m.is_active = 1
        )
        AND e.is_active = 1
        
        UNION ALL
        
        SELECT 
            e.employee_id,
            e.first_name + ' ' + e.last_name AS employee_name,
            e.manager_id,
            m.first_name + ' ' + m.last_name AS manager_name,
            d.department_name,
            p.position_title,
            eh.hierarchy_level + 1
        FROM Employee e
        INNER JOIN Employee m ON e.manager_id = m.employee_id
        LEFT JOIN Department d ON e.department_id = d.department_id
        LEFT JOIN Position p ON e.position_id = p.position_id
        INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
        WHERE e.is_active = 1
    )
    SELECT 
        employee_id AS EmployeeID,
        employee_name AS EmployeeName,
        manager_id AS ManagerID,
        manager_name AS ManagerName,
        department_name AS Department,
        position_title AS Position,
        hierarchy_level AS HierarchyLevel
    FROM EmployeeHierarchy
    ORDER BY hierarchy_level, department_name, employee_name;
END
GO
CREATE PROCEDURE AssignShiftToEmployee
    @EmployeeID INT,
    @ShiftID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @ShiftID AND status = 'Active')
        BEGIN
            RAISERROR('Shift with ID %d does not exist or is not active.', 16, 1, @ShiftID);
            RETURN;
        END
        
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
         
        IF EXISTS (
            SELECT 1 FROM ShiftAssignment 
            WHERE employee_id = @EmployeeID 
            AND status IN ('Active', 'Scheduled')
            AND (
                (@StartDate BETWEEN start_date AND end_date) OR
                (@EndDate BETWEEN start_date AND end_date) OR
                (start_date BETWEEN @StartDate AND @EndDate)
            )
        )
        BEGIN
            RAISERROR('Employee already has shift assignments that overlap with the specified date range.', 16, 1);
            RETURN;
        END
        
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
        VALUES (@EmployeeID, @ShiftID, @StartDate, @EndDate, 'Scheduled');
        
        COMMIT TRANSACTION;
        
        SELECT 'Shift assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
CREATE PROCEDURE UpdateShiftStatus
    @ShiftAssignmentID INT,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM ShiftAssignment WHERE assignment_id = @ShiftAssignmentID)
        BEGIN
            RAISERROR('Shift assignment with ID %d does not exist.', 16, 1, @ShiftAssignmentID);
            RETURN;
        END
 
        IF @Status NOT IN ('Approved', 'Cancelled', 'Entered', 'Expired', 'Postponed', 'Rejected', 'Submitted')
        BEGIN
            RAISERROR('Invalid status value. Allowed values: Approved, Cancelled, Entered, Expired, Postponed, Rejected, Submitted.', 16, 1);
            RETURN;
        END
        
        UPDATE ShiftAssignment 
        SET status = @Status 
        WHERE assignment_id = @ShiftAssignmentID;
        
        SELECT 'Shift status updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE PROCEDURE AssignShiftToDepartment
    @DepartmentID INT,
    @ShiftID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department with ID %d does not exist.', 16, 1, @DepartmentID);
            RETURN;
        END
       
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @ShiftID AND status = 'Active')
        BEGIN
            RAISERROR('Shift with ID %d does not exist or is not active.', 16, 1, @ShiftID);
            RETURN;
        END
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
 
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
        SELECT 
            e.employee_id,
            @ShiftID,
            @StartDate,
            @EndDate,
            'Scheduled'
        FROM Employee e
        WHERE e.department_id = @DepartmentID 
        AND e.is_active = 1;
        
        DECLARE @AffectedRows INT = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SELECT CONCAT('Shift assigned to ', @AffectedRows, ' employees in department') AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE AssignCustomShift
    @EmployeeID INT,
    @ShiftName VARCHAR(50),
    @ShiftType VARCHAR(50),
    @StartTime TIME,
    @EndTime TIME,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
 
        IF @StartTime >= @EndTime
        BEGIN
            RAISERROR('Start time cannot be after or equal to end time.', 16, 1);
            RETURN;
        END
 
        INSERT INTO ShiftSchedule (name, type, start_time, end_time, shift_date, status)
        VALUES (@ShiftName, @ShiftType, @StartTime, @EndTime, NULL, 'Custom');
        
        DECLARE @NewShiftID INT = SCOPE_IDENTITY();
        
 
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
        VALUES (@EmployeeID, @NewShiftID, @StartDate, @EndDate, 'Scheduled');
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Custom shift created and assigned successfully' AS Message,
            @NewShiftID AS NewShiftID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ConfigureSplitShift
    @ShiftName VARCHAR(50),
    @FirstSlotStart TIME,
    @FirstSlotEnd TIME,
    @SecondSlotStart TIME,
    @SecondSlotEnd TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
   
        IF @FirstSlotStart >= @FirstSlotEnd
        BEGIN
            RAISERROR('First slot start time cannot be after or equal to end time.', 16, 1);
            RETURN;
        END
  
        IF @SecondSlotStart >= @SecondSlotEnd
        BEGIN
            RAISERROR('Second slot start time cannot be after or equal to end time.', 16, 1);
            RETURN;
        END
    
        IF @SecondSlotStart < @FirstSlotEnd
        BEGIN
            RAISERROR('Second slot must start after first slot ends.', 16, 1);
            RETURN;
        END
  
        DECLARE @BreakDuration INT = DATEDIFF(MINUTE, @FirstSlotEnd, @SecondSlotStart);
 
        INSERT INTO ShiftSchedule (
            name, 
            type, 
            start_time, 
            end_time, 
            break_duration, 
            status
        )
        VALUES (
            @ShiftName,
            'Split',
            @FirstSlotStart,
            @SecondSlotEnd,
            @BreakDuration,
            'Active'
        );
        
        SELECT 
            'Split shift configured successfully' AS Message,
            SCOPE_IDENTITY() AS NewShiftID;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE EnableFirstInLastOut
    @Enable BIT
AS
BEGIN
    SET NOCOUNT ON;
 
    
    IF @Enable = 1
        SELECT 'First in/last out attendance processing enabled' AS Message;
    ELSE
        SELECT 'First in/last out attendance processing disabled' AS Message;
END
GO
 
CREATE PROCEDURE TagAttendanceSource
    @AttendanceID INT,
    @SourceType VARCHAR(20),
    @DeviceID INT,
    @Latitude DECIMAL(10,7),
    @Longitude DECIMAL(10,7)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Attendance WHERE attendance_id = @AttendanceID)
        BEGIN
            RAISERROR('Attendance record with ID %d does not exist.', 16, 1, @AttendanceID);
            RETURN;
        END
 
        IF @SourceType NOT IN ('Device', 'Terminal', 'GPS', 'Manual')
        BEGIN
            RAISERROR('Invalid source type. Allowed values: Device, Terminal, GPS, Manual.', 16, 1);
            RETURN;
        END
  
        IF @DeviceID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Device WHERE device_id = @DeviceID)
        BEGIN
            RAISERROR('Device with ID %d does not exist.', 16, 1, @DeviceID);
            RETURN;
        END
 
        IF (@Latitude IS NOT NULL AND (@Latitude < -90 OR @Latitude > 90))
            OR (@Longitude IS NOT NULL AND (@Longitude < -180 OR @Longitude > 180))
        BEGIN
            RAISERROR('Invalid GPS coordinates. Latitude must be between -90 and 90, Longitude between -180 and 180.', 16, 1);
            RETURN;
        END
        
        INSERT INTO AttendanceSource (attendance_id, device_id, source_type, latitude, longitude, recorded_at)
        VALUES (@AttendanceID, @DeviceID, @SourceType, @Latitude, @Longitude, GETDATE());
        
        SELECT 'Attendance source tagged successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE SyncOfflineAttendance
    @DeviceID INT,
    @EmployeeID INT,
    @ClockTime DATETIME,
    @Type VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Device WHERE device_id = @DeviceID)
        BEGIN
            RAISERROR('Device with ID %d does not exist.', 16, 1, @DeviceID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
         
        IF @Type NOT IN ('IN', 'OUT')
        BEGIN
            RAISERROR('Invalid clock type. Allowed values: IN, OUT.', 16, 1);
            RETURN;
        END
    
        IF @ClockTime > GETDATE()
        BEGIN
            RAISERROR('Clock time cannot be in the future.', 16, 1);
            RETURN;
        END
 
        DECLARE @AttendanceDate DATE = CAST(@ClockTime AS DATE);
        DECLARE @AttendanceID INT;
        
        SELECT @AttendanceID = attendance_id 
        FROM Attendance 
        WHERE employee_id = @EmployeeID 
        AND CAST(entry_time AS DATE) = @AttendanceDate;
        
        IF @AttendanceID IS NULL
        BEGIN
 
            INSERT INTO Attendance (employee_id, entry_time, login_method)
            VALUES (@EmployeeID, @ClockTime, 'Offline Device');
            
            SET @AttendanceID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
 
            IF @Type = 'OUT'
            BEGIN
                UPDATE Attendance 
                SET exit_time = @ClockTime, 
                    logout_method = 'Offline Device',
                    duration = DATEDIFF(MINUTE, entry_time, @ClockTime)
                WHERE attendance_id = @AttendanceID;
            END
        END
 
        INSERT INTO AttendanceSource (attendance_id, device_id, source_type, recorded_at)
        VALUES (@AttendanceID, @DeviceID, 'Offline Sync', GETDATE());
        
        COMMIT TRANSACTION;
        
        SELECT 'Offline attendance synced successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE LogAttendanceEdit
    @AttendanceID INT,
    @EditedBy INT,
    @OldValue DATETIME,
    @NewValue DATETIME,
    @EditTimestamp DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Attendance WHERE attendance_id = @AttendanceID)
        BEGIN
            RAISERROR('Attendance record with ID %d does not exist.', 16, 1, @AttendanceID);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EditedBy AND is_active = 1)
        BEGIN
            RAISERROR('Editor with ID %d does not exist or is not active.', 16, 1, @EditedBy);
            RETURN;
        END
 
        IF @EditTimestamp > GETDATE()
        BEGIN
            RAISERROR('Edit timestamp cannot be in the future.', 16, 1);
            RETURN;
        END
        
        INSERT INTO AttendanceLog (attendance_id, actor, timestamp, reason)
        VALUES (@AttendanceID, @EditedBy, @EditTimestamp, 
                CONCAT('Clock time changed from ', @OldValue, ' to ', @NewValue));
        
        SELECT 'Attendance edit logged successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ApplyHolidayOverrides
    @HolidayID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
        
   
        IF NOT EXISTS (SELECT 1 FROM Exception WHERE exception_id = @HolidayID AND category = 'Holiday')
        BEGIN
            RAISERROR('Holiday with ID %d does not exist.', 16, 1, @HolidayID);
            RETURN;
        END
        
        DECLARE @HolidayDate DATE;
        SELECT @HolidayDate = date FROM Exception WHERE exception_id = @HolidayID;
 
        IF NOT EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @HolidayDate)
        BEGIN
            INSERT INTO Attendance (employee_id, entry_time, exception_id, login_method)
            VALUES (@EmployeeID, @HolidayDate, @HolidayID, 'Holiday Override');
        END
        ELSE
        BEGIN
            UPDATE Attendance 
            SET exception_id = @HolidayID
            WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @HolidayDate;
        END
        
        SELECT 'Holiday override applied successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ManageUserAccounts
    @UserID INT,
    @Role VARCHAR(50),
    @Action VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @UserID AND is_active = 1)
        BEGIN
            RAISERROR('User with ID %d does not exist or is not active.', 16, 1, @UserID);
            RETURN;
        END
 
        IF @Action NOT IN ('ADD', 'REMOVE', 'UPDATE')
        BEGIN
            RAISERROR('Invalid action. Allowed values: ADD, REMOVE, UPDATE.', 16, 1);
            RETURN;
        END
 
        DECLARE @RoleID INT;
        SELECT @RoleID = role_id FROM Role WHERE role_name = @Role;
        
        IF @RoleID IS NULL
        BEGIN
            RAISERROR('Role %s does not exist.', 16, 1, @Role);
            RETURN;
        END
        
        IF @Action = 'ADD'
        BEGIN
 
            IF EXISTS (SELECT 1 FROM Employee_Role WHERE employee_id = @UserID AND role_id = @RoleID)
            BEGIN
                RAISERROR('User already has role %s.', 16, 1, @Role);
                RETURN;
            END
            
            INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
            VALUES (@UserID, @RoleID, GETDATE());
        END
        ELSE IF @Action = 'REMOVE'
        BEGIN
  
            IF NOT EXISTS (SELECT 1 FROM Employee_Role WHERE employee_id = @UserID AND role_id = @RoleID)
            BEGIN
                RAISERROR('User does not have role %s.', 16, 1, @Role);
                RETURN;
            END
            
            DELETE FROM Employee_Role 
            WHERE employee_id = @UserID AND role_id = @RoleID;
        END
        ELSE IF @Action = 'UPDATE'
        BEGIN
 
            IF NOT EXISTS (
                SELECT 1 FROM Employee_Role er 
                JOIN Role r ON er.role_id = r.role_id 
                WHERE er.employee_id = @UserID 
                AND r.role_name LIKE '%Payroll%'
            )
            BEGIN
                RAISERROR('User does not have any payroll role to update.', 16, 1);
                RETURN;
            END
            DELETE FROM Employee_Role 
            WHERE employee_id = @UserID 
            AND role_id IN (SELECT role_id FROM Role WHERE role_name LIKE '%Payroll%');
 
            INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
            VALUES (@UserID, @RoleID, GETDATE());
        END
        
        COMMIT TRANSACTION;
        
        SELECT CONCAT('User account management completed: ', @Action, ' role ', @Role) AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
DROP PROCEDURE IF EXISTS CreateContract;
DROP PROCEDURE IF EXISTS RenewContract;
DROP PROCEDURE IF EXISTS ApproveLeaveRequest;
DROP PROCEDURE IF EXISTS AssignMission;
DROP PROCEDURE IF EXISTS ReviewReimbursement;
DROP PROCEDURE IF EXISTS GetActiveContracts;
DROP PROCEDURE IF EXISTS GetTeamByManager;
DROP PROCEDURE IF EXISTS UpdateLeavePolicy;
DROP PROCEDURE IF EXISTS GetExpiringContracts;
DROP PROCEDURE IF EXISTS AssignDepartmentHead;
DROP PROCEDURE IF EXISTS CreateEmployeeProfile;
DROP PROCEDURE IF EXISTS UpdateEmployeeProfile;
DROP PROCEDURE IF EXISTS SetProfileCompleteness;
DROP PROCEDURE IF EXISTS GenerateProfileReport;
DROP PROCEDURE IF EXISTS CreateShiftType;
DROP PROCEDURE IF EXISTS CreateShiftName;
DROP PROCEDURE IF EXISTS AssignRotationalShift;
DROP PROCEDURE IF EXISTS NotifyShiftExpiry;
DROP PROCEDURE IF EXISTS DefineShortTimeRules;
DROP PROCEDURE IF EXISTS SetGracePeriod;
DROP PROCEDURE IF EXISTS DefinePenaltyThreshold;
DROP PROCEDURE IF EXISTS DefinePermissionLimits;
DROP PROCEDURE IF EXISTS EscalatePendingRequests;
DROP PROCEDURE IF EXISTS LinkVacationToShift;
DROP PROCEDURE IF EXISTS ConfigureLeavePolicies;
DROP PROCEDURE IF EXISTS AuthenticateLeaveAdmin;
DROP PROCEDURE IF EXISTS ApplyLeaveConfiguration;
DROP PROCEDURE IF EXISTS UpdateLeaveEntitlements;
DROP PROCEDURE IF EXISTS ConfigureLeaveEligibility;
DROP PROCEDURE IF EXISTS ManageLeaveTypes;
DROP PROCEDURE IF EXISTS AssignLeaveEntitlement;
DROP PROCEDURE IF EXISTS ConfigureLeaveRules;
DROP PROCEDURE IF EXISTS ConfigureSpecialLeave;
DROP PROCEDURE IF EXISTS SetLeaveYearRules;
DROP PROCEDURE IF EXISTS AdjustLeaveBalance;
DROP PROCEDURE IF EXISTS ManageLeaveRoles;
DROP PROCEDURE IF EXISTS FinalizeLeaveRequest;
DROP PROCEDURE IF EXISTS OverrideLeaveDecision;
DROP PROCEDURE IF EXISTS BulkProcessLeaveRequests;
DROP PROCEDURE IF EXISTS VerifyMedicalLeave;
DROP PROCEDURE IF EXISTS SyncLeaveBalances;
DROP PROCEDURE IF EXISTS ProcessLeaveCarryForward;
DROP PROCEDURE IF EXISTS SyncLeaveToAttendance;
DROP PROCEDURE IF EXISTS UpdateInsuranceBrackets;
DROP PROCEDURE IF EXISTS ApprovePolicyUpdate;
GO
CREATE PROCEDURE CreateContract
    @EmployeeID INT,
    @Type VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF @Type NOT IN ('FullTime', 'PartTime', 'Temporary', 'Contractor')
        BEGIN
            RAISERROR('Invalid contract type. Allowed values: FullTime, PartTime, Temporary, Contractor.', 16, 1);
            RETURN;
        END
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
 
        IF EXISTS (
            SELECT 1 FROM Contract c
            JOIN Employee e ON e.contract_id = c.contract_id
            WHERE e.employee_id = @EmployeeID
            AND c.current_state = 'Active'
            AND (
                (@StartDate BETWEEN c.start_date AND c.end_date) OR
                (@EndDate BETWEEN c.start_date AND c.end_date) OR
                (c.start_date BETWEEN @StartDate AND @EndDate)
            )
        )
        BEGIN
            RAISERROR('Employee already has an active contract that overlaps with the specified date range.', 16, 1);
            RETURN;
        END
 
        INSERT INTO Contract (type, start_date, end_date, current_state)
        VALUES (@Type, @StartDate, @EndDate, 'Active');
        
        DECLARE @NewContractID INT = SCOPE_IDENTITY();
 
        UPDATE Employee 
        SET contract_id = @NewContractID 
        WHERE employee_id = @EmployeeID;
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Contract created successfully' AS Message,
            @NewContractID AS NewContractID;
            
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE RenewContract
    @ContractID INT,
    @NewEndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Contract WHERE contract_id = @ContractID)
        BEGIN
            RAISERROR('Contract with ID %d does not exist.', 16, 1, @ContractID);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Contract WHERE contract_id = @ContractID AND current_state = 'Active')
        BEGIN
            RAISERROR('Contract with ID %d is not active.', 16, 1, @ContractID);
            RETURN;
        END
        
        DECLARE @CurrentEndDate DATE;
        SELECT @CurrentEndDate = end_date FROM Contract WHERE contract_id = @ContractID;
        
        IF @NewEndDate <= @CurrentEndDate
        BEGIN
            RAISERROR('New end date must be after the current end date.', 16, 1);
            RETURN;
        END
        
        UPDATE Contract 
        SET end_date = @NewEndDate 
        WHERE contract_id = @ContractID;
        
        SELECT 'Contract renewed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ApproveLeaveRequest
    @LeaveRequestID INT,
    @ApproverID INT,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request with ID %d does not exist.', 16, 1, @LeaveRequestID);
            RETURN;
        END
    
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ApproverID AND is_active = 1)
        BEGIN
            RAISERROR('Approver with ID %d does not exist or is not active.', 16, 1, @ApproverID);
            RETURN;
        END
 
        IF @Status NOT IN ('Approved', 'Rejected', 'Pending')
        BEGIN
            RAISERROR('Invalid status. Allowed values: Approved, Rejected, Pending.', 16, 1);
            RETURN;
        END
  
        DECLARE @CurrentStatus VARCHAR(50);
        SELECT @CurrentStatus = status FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        
        IF @CurrentStatus IN ('Approved', 'Rejected')
        BEGIN
            RAISERROR('Leave request has already been processed and cannot be modified.', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET 
            status = @Status,
            approval_timing = GETDATE()
        WHERE request_id = @LeaveRequestID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Leave request processed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE AssignMission
    @EmployeeID INT,
    @ManagerID INT,
    @Destination VARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
    
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND is_active = 1)
        BEGIN
            RAISERROR('Manager with ID %d does not exist or is not active.', 16, 1, @ManagerID);
            RETURN;
        END
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
 
        IF EXISTS (
            SELECT 1 FROM Mission 
            WHERE employee_id = @EmployeeID 
            AND status IN ('Assigned', 'In Progress')
            AND (
                (@StartDate BETWEEN start_date AND end_date) OR
                (@EndDate BETWEEN start_date AND end_date) OR
                (start_date BETWEEN @StartDate AND @EndDate)
            )
        )
        BEGIN
            RAISERROR('Employee already has a mission that overlaps with the specified date range.', 16, 1);
            RETURN;
        END
        
        INSERT INTO Mission (destination, start_date, end_date, status, employee_id, manager_id)
        VALUES (@Destination, @StartDate, @EndDate, 'Assigned', @EmployeeID, @ManagerID);
        
        SELECT 'Mission assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ReviewReimbursement
    @ClaimID INT,
    @ApproverID INT,
    @Decision VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM Reimbursement WHERE reimbursement_id = @ClaimID)
        BEGIN
            RAISERROR('Reimbursement claim with ID %d does not exist.', 16, 1, @ClaimID);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ApproverID AND is_active = 1)
        BEGIN
            RAISERROR('Approver with ID %d does not exist or is not active.', 16, 1, @ApproverID);
            RETURN;
        END
        IF @Decision NOT IN ('Approved', 'Rejected')
        BEGIN
            RAISERROR('Invalid decision. Allowed values: Approved, Rejected.', 16, 1);
            RETURN;
        END
 
        DECLARE @CurrentStatus VARCHAR(50);
        SELECT @CurrentStatus = current_status FROM Reimbursement WHERE reimbursement_id = @ClaimID;
        
        IF @CurrentStatus IN ('Approved', 'Rejected')
        BEGIN
            RAISERROR('Reimbursement claim has already been processed.', 16, 1);
            RETURN;
        END
        
        UPDATE Reimbursement 
        SET 
            current_status = @Decision,
            approval_date = CASE WHEN @Decision = 'Approved' THEN CAST(GETDATE() AS DATE) ELSE NULL END
        WHERE reimbursement_id = @ClaimID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Reimbursement claim processed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE GetActiveContracts
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.contract_id,
        c.type,
        c.start_date,
        c.end_date,
        c.current_state,
        e.employee_id,
        e.first_name + ' ' + e.last_name AS employee_name,
        d.department_name
    FROM Contract c
    JOIN Employee e ON e.contract_id = c.contract_id
    LEFT JOIN Department d ON e.department_id = d.department_id
    WHERE c.current_state = 'Active'
    AND e.is_active = 1
    ORDER BY c.end_date, e.employee_id;
END
GO
 
CREATE PROCEDURE GetTeamByManager
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
   
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND is_active = 1)
    BEGIN
        RAISERROR('Manager with ID %d does not exist or is not active.', 16, 1, @ManagerID);
        RETURN;
    END
    
    SELECT 
        e.employee_id,
        e.first_name + ' ' + e.last_name AS employee_name,
        e.email,
        e.phone,
        p.position_title,
        d.department_name
    FROM Employee e
    LEFT JOIN Position p ON e.position_id = p.position_id
    LEFT JOIN Department d ON e.department_id = d.department_id
    WHERE e.manager_id = @ManagerID
    AND e.is_active = 1
    ORDER BY e.first_name, e.last_name;
END
GO
 
CREATE PROCEDURE UpdateLeavePolicy
    @PolicyID INT,
    @EligibilityRules VARCHAR(200),
    @NoticePeriod INT
AS
BEGIN
    SET NOCOUNT ON;
     
    IF NOT EXISTS (SELECT 1 FROM [Leave] WHERE leave_id = @PolicyID)
    BEGIN
        RAISERROR('Leave policy with ID %d does not exist.', 16, 1, @PolicyID);
        RETURN;
    END
 
    IF @NoticePeriod < 0
    BEGIN
        RAISERROR('Notice period cannot be negative.', 16, 1);
        RETURN;
    END
 
    UPDATE [Leave] 
    SET leave_description = @EligibilityRules 
    WHERE leave_id = @PolicyID;
    
    SELECT 'Leave policy updated successfully' AS Message;
END
GO
 
CREATE PROCEDURE GetExpiringContracts
    @DaysBefore INT
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @DaysBefore < 0
    BEGIN
        RAISERROR('Days before parameter cannot be negative.', 16, 1);
        RETURN;
    END
    
    SELECT 
        c.contract_id,
        c.type,
        c.start_date,
        c.end_date,
        e.employee_id,
        e.first_name + ' ' + e.last_name AS employee_name,
        d.department_name,
        DATEDIFF(DAY, GETDATE(), c.end_date) AS days_until_expiry
    FROM Contract c
    JOIN Employee e ON e.contract_id = c.contract_id
    LEFT JOIN Department d ON e.department_id = d.department_id
    WHERE c.current_state = 'Active'
    AND e.is_active = 1
    AND c.end_date BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, @DaysBefore, CAST(GETDATE() AS DATE))
    ORDER BY c.end_date, e.employee_id;
END
GO
 
CREATE PROCEDURE AssignDepartmentHead
    @DepartmentID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department with ID %d does not exist.', 16, 1, @DepartmentID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND is_active = 1)
        BEGIN
            RAISERROR('Manager with ID %d does not exist or is not active.', 16, 1, @ManagerID);
            RETURN;
        END
    
        UPDATE Department 
        SET department_head_id = @ManagerID 
        WHERE department_id = @DepartmentID;
         
        UPDATE Employee 
        SET department_id = @DepartmentID 
        WHERE employee_id = @ManagerID;
        
        COMMIT TRANSACTION;
        
        SELECT 'Department head assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE CreateEmployeeProfile
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @RoleID INT,
    @HireDate DATE,
    @Email VARCHAR(100),
    @Phone VARCHAR(20),
    @NationalID VARCHAR(50),
    @DateOfBirth DATE,
    @CountryOfBirth VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF @Email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('Invalid email format.', 16, 1);
            RETURN;
        END
        
        IF EXISTS (SELECT 1 FROM Employee WHERE email = @Email)
        BEGIN
            RAISERROR('Employee with email %s already exists.', 16, 1, @Email);
            RETURN;
        END
 
        IF EXISTS (SELECT 1 FROM Employee WHERE national_id = @NationalID)
        BEGIN
            RAISERROR('Employee with National ID %s already exists.', 16, 1, @NationalID);
            RETURN ;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department with ID %d does not exist.', 16, 1, @DepartmentID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM Role WHERE role_id = @RoleID)
        BEGIN
            RAISERROR('Role with ID %d does not exist.', 16, 1, @RoleID);
            RETURN;
        END
        
       
        IF @DateOfBirth > DATEADD(YEAR, -14, GETDATE())
        BEGIN
            RAISERROR('Employee must be at least 14 years old.', 16, 1);
            RETURN;
        END
        
        IF @HireDate > CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Hire date cannot be in the future.', 16, 1);
            RETURN;
        END
        INSERT INTO Employee (
            first_name, last_name, department_id, hire_date, email, phone,
            national_id, date_of_birth, country_of_birth, is_active, profile_completion
        )
        VALUES (
            @FirstName, @LastName, @DepartmentID, @HireDate, @Email, @Phone,
            @NationalID, @DateOfBirth, @CountryOfBirth, 1, 0
        );
        
        DECLARE @NewEmployeeID INT = SCOPE_IDENTITY();
      
        INSERT INTO Employee_Role (employee_id, role_id, assigned_date)
        VALUES (@NewEmployeeID, @RoleID, GETDATE());
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Employee profile created successfully' AS Message,
            @NewEmployeeID AS NewEmployeeID;
            
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE UpdateEmployeeProfile
    @EmployeeID INT,
    @FieldName VARCHAR(50),
    @NewValue VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee with ID %d does not exist.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF @FieldName NOT IN (
            'first_name', 'last_name', 'email', 'phone', 'address', 
            'national_id', 'emergency_contact_name', 'emergency_contact_phone'
        )
        BEGIN
            RAISERROR('Invalid field name. Allowed fields: first_name, last_name, email, phone, address, national_id, emergency_contact_name, emergency_contact_phone.', 16, 1);
            RETURN;
        END
         
        IF @FieldName = 'email' AND @NewValue NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('Invalid email format.', 16, 1);
            RETURN;
        END
         
        IF @FieldName = 'email' AND EXISTS (SELECT 1 FROM Employee WHERE email = @NewValue AND employee_id != @EmployeeID)
        BEGIN
            RAISERROR('Email %s is already in use by another employee.', 16, 1, @NewValue);
            RETURN;
        END
 
        IF @FieldName = 'national_id' AND EXISTS (SELECT 1 FROM Employee WHERE national_id = @NewValue AND employee_id != @EmployeeID)
        BEGIN
            RAISERROR('National ID %s is already in use by another employee.', 16, 1, @NewValue);
            RETURN;
        END
         
        DECLARE @SQL NVARCHAR(1000);
        SET @SQL = 'UPDATE Employee SET ' + QUOTENAME(@FieldName) + ' = @NewValue WHERE employee_id = @EmployeeID';
        
        EXEC sp_executesql @SQL, N'@NewValue VARCHAR(255), @EmployeeID INT', @NewValue, @EmployeeID;
        
        SELECT 'Employee profile updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE SetProfileCompleteness
    @EmployeeID INT,
    @CompletenessPercentage INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
    
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee with ID %d does not exist.', 16, 1, @EmployeeID);
            RETURN;
        END
  
        IF @CompletenessPercentage < 0 OR @CompletenessPercentage > 100
        BEGIN
            RAISERROR('Completeness percentage must be between 0 and 100.', 16, 1);
            RETURN;
        END
        
        UPDATE Employee 
        SET profile_completion = @CompletenessPercentage 
        WHERE employee_id = @EmployeeID;
        
        SELECT 
            'Profile completeness updated successfully' AS Message,
            @CompletenessPercentage AS UpdatedCompleteness;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE GenerateProfileReport
    @FilterField VARCHAR(50),
    @FilterValue VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @FilterField NOT IN ('department_id', 'gender', 'country_of_birth', 'employment_status')
    BEGIN
        RAISERROR('Invalid filter field. Allowed fields: department_id, gender, country_of_birth, employment_status.', 16, 1);
        RETURN;
    END
    
    DECLARE @SQL NVARCHAR(1000);
    
    IF @FilterField = 'department_id'
    BEGIN
        SET @SQL = '
            SELECT 
                e.employee_id,
                e.first_name + '' '' + e.last_name AS employee_name,
                e.gender,
                e.country_of_birth,
                e.employment_status,
                d.department_name,
                p.position_title
            FROM Employee e
            LEFT JOIN Department d ON e.department_id = d.department_id
            LEFT JOIN Position p ON e.position_id = p.position_id
            WHERE e.department_id = @FilterValue
            AND e.is_active = 1
            ORDER BY e.first_name, e.last_name';
    END
    ELSE
    BEGIN
        SET @SQL = '
            SELECT 
                e.employee_id,
                e.first_name + '' '' + e.last_name AS employee_name,
                e.gender,
                e.country_of_birth,
                e.employment_status,
                d.department_name,
                p.position_title
            FROM Employee e
            LEFT JOIN Department d ON e.department_id = d.department_id
            LEFT JOIN Position p ON e.position_id = p.position_id
            WHERE ' + QUOTENAME(@FilterField) + ' = @FilterValue
            AND e.is_active = 1
            ORDER BY e.first_name, e.last_name';
    END
    
    EXEC sp_executesql @SQL, N'@FilterValue VARCHAR(100)', @FilterValue;
END
GO
 
CREATE PROCEDURE CreateShiftType
    @ShiftID INT,
    @Name VARCHAR(100),
    @Type VARCHAR(50),
    @Start_Time TIME,
    @End_Time TIME,
    @Break_Duration INT,
    @Shift_Date DATE,
    @Status VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF EXISTS (SELECT 1 FROM ShiftSchedule WHERE name = @Name)
        BEGIN
            RAISERROR('Shift type with name %s already exists.', 16, 1, @Name);
            RETURN;
        END
 
        IF @Start_Time >= @End_Time
        BEGIN
            RAISERROR('Start time cannot be after or equal to end time.', 16, 1);
            RETURN;
        END
 
        IF @Break_Duration < 0
        BEGIN
            RAISERROR('Break duration cannot be negative.', 16, 1);
            RETURN;
        END
         
        IF @Status NOT IN ('Active', 'Inactive', 'Pending')
        BEGIN
            RAISERROR('Invalid status. Allowed values: Active, Inactive, Pending.', 16, 1);
            RETURN;
        END
        
        INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, shift_date, status)
        VALUES (@Name, @Type, @Start_Time, @End_Time, @Break_Duration, @Shift_Date, @Status);
        
        SELECT 'Shift type created successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE CreateShiftName
    @ShiftName VARCHAR(50),
    @ShiftTypeID INT,
    @Description VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF EXISTS (SELECT 1 FROM ShiftSchedule WHERE name = @ShiftName)
        BEGIN
            RAISERROR('Shift name %s already exists.', 16, 1, @ShiftName);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @ShiftTypeID)
        BEGIN
            RAISERROR('Shift type with ID %d does not exist.', 16, 1, @ShiftTypeID);
            RETURN;
        END
 
        UPDATE ShiftSchedule 
        SET 
            name = @ShiftName,
            type = (SELECT type FROM ShiftSchedule WHERE shift_id = @ShiftTypeID),
            break_duration = COALESCE(break_duration, 0)
        WHERE shift_id = @ShiftTypeID;
        
        SELECT 'Shift name created successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE AssignRotationalShift
    @EmployeeID INT,
    @ShiftCycle INT,
    @StartDate DATE,
    @EndDate DATE,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date cannot be after end date.', 16, 1);
            RETURN;
        END
 
        IF @Status NOT IN ('Active', 'Scheduled', 'Completed', 'Cancelled')
        BEGIN
            RAISERROR('Invalid status. Allowed values: Active, Scheduled, Completed, Cancelled.', 16, 1);
            RETURN;
        END
  
        IF EXISTS (
            SELECT 1 FROM ShiftAssignment sa
            JOIN ShiftSchedule ss ON sa.shift_id = ss.shift_id
            WHERE sa.employee_id = @EmployeeID
            AND sa.status IN ('Active', 'Scheduled')
            AND ss.type = 'Rotational'
            AND (
                (@StartDate BETWEEN sa.start_date AND sa.end_date) OR
                (@EndDate BETWEEN sa.start_date AND sa.end_date) OR
                (sa.start_date BETWEEN @StartDate AND @EndDate)
            )
        )
        BEGIN
            RAISERROR('Employee already has a rotational shift assignment that overlaps with the specified date range.', 16, 1);
            RETURN;
        END
 
        DECLARE @RotationalShiftID INT;
        
        SELECT @RotationalShiftID = shift_id 
        FROM ShiftSchedule 
        WHERE type = 'Rotational' 
        AND name LIKE '%Rotational%' 
        AND status = 'Active';
        
        IF @RotationalShiftID IS NULL
        BEGIN
   
            INSERT INTO ShiftSchedule (name, type, start_time, end_time, break_duration, status)
            VALUES ('Rotational Shift ' + CAST(@ShiftCycle AS VARCHAR), 'Rotational', '08:00', '17:00', 60, 'Active');
            
            SET @RotationalShiftID = SCOPE_IDENTITY();
        END
 
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
        VALUES (@EmployeeID, @RotationalShiftID, @StartDate, @EndDate, @Status);
        
        COMMIT TRANSACTION;
        
        SELECT 'Rotational shift assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE NotifyShiftExpiry
    @EmployeeID INT,
    @ShiftAssignmentID INT,
    @ExpiryDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM ShiftAssignment WHERE assignment_id = @ShiftAssignmentID AND employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Shift assignment with ID %d does not exist for this employee.', 16, 1, @ShiftAssignmentID);
            RETURN;
        END
 
        IF @ExpiryDate <= CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Expiry date must be in the future.', 16, 1);
            RETURN;
        END
 
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, timestamp, urgency, notification_type)
        VALUES (
            CONCAT('Shift assignment ', @ShiftAssignmentID, ' for employee ', @EmployeeID, ' is expiring on ', @ExpiryDate),
            GETDATE(),
            'Medium',
            'Shift Expiry'
        );
        
        SET @NotificationID = SCOPE_IDENTITY();
        
 
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        SELECT 
            er.employee_id,
            @NotificationID,
            'Pending'
        FROM Employee_Role er
        JOIN Role r ON er.role_id = r.role_id
        WHERE r.role_name LIKE '%HR%Admin%'
        AND er.employee_id IN (SELECT employee_id FROM Employee WHERE is_active = 1);
        
        SELECT 'Shift expiry notification created successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE DefineShortTimeRules
    @RuleName VARCHAR(50),
    @LateMinutes INT,
    @EarlyLeaveMinutes INT,
    @PenaltyType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF EXISTS (SELECT 1 FROM Exception WHERE name = @RuleName AND category = 'ShortTime')
        BEGIN
            RAISERROR('Short time rule with name %s already exists.', 16, 1, @RuleName);
            RETURN;
        END
  
        IF @LateMinutes < 0 OR @EarlyLeaveMinutes < 0
        BEGIN
            RAISERROR('Late minutes and early leave minutes cannot be negative.', 16, 1);
            RETURN;
        END
 
        IF @PenaltyType NOT IN ('Deduction', 'Warning', 'NoPenalty', 'HalfDay')
        BEGIN
            RAISERROR('Invalid penalty type. Allowed values: Deduction, Warning, NoPenalty, HalfDay.', 16, 1);
            RETURN;
        END
 
        INSERT INTO Exception (name, category, date, status)
        VALUES (@RuleName, 'ShortTime', GETDATE(), 'Active');
        
        SELECT 'Short time rule defined successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE SetGracePeriod
    @Minutes INT
AS
BEGIN
    SET NOCOUNT ON;
     IF @Minutes < 0
    BEGIN
        RAISERROR('Grace period minutes cannot be negative.', 16, 1);
        RETURN;
    END
    
 
    
    SELECT CONCAT('Grace period set to ', @Minutes, ' minutes') AS Message;
END
GO
 
CREATE PROCEDURE DefinePenaltyThreshold
    @LateMinutes INT,
    @DeductionType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
 
    IF @LateMinutes < 0
    BEGIN
        RAISERROR('Late minutes cannot be negative.', 16, 1);
        RETURN;
    END
 
    IF @DeductionType NOT IN ('HalfDay', 'FullDay', 'Percentage', 'FixedAmount')
    BEGIN
        RAISERROR('Invalid deduction type. Allowed values: HalfDay, FullDay, Percentage, FixedAmount.', 16, 1);
        RETURN;
    END
   
    
    SELECT CONCAT('Penalty threshold set: ', @LateMinutes, ' minutes late = ', @DeductionType, ' deduction') AS Message;
END
GO

CREATE PROCEDURE DefinePermissionLimits
    @MinHours INT,
    @MaxHours INT
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @MinHours < 0
    BEGIN
        RAISERROR('Minimum hours cannot be negative.', 16, 1);
        RETURN;
    END
    
    IF @MaxHours <= @MinHours
    BEGIN
        RAISERROR('Maximum hours must be greater than minimum hours.', 16, 1);
        RETURN;
    END
     
    
    SELECT CONCAT('Permission limits set: Min=', @MinHours, ' hours, Max=', @MaxHours, ' hours') AS Message;
END
GO

CREATE PROCEDURE EscalatePendingRequests
    @Deadline DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF @Deadline > GETDATE()
        BEGIN
            RAISERROR('Deadline must be in the past for escalation.', 16, 1);
            RETURN;
        END
 
        DECLARE @PendingRequests TABLE (RequestID INT, EmployeeID INT, ManagerID INT);
        
        INSERT INTO @PendingRequests (RequestID, EmployeeID, ManagerID)
        SELECT 
            lr.request_id,
            lr.employee_id,
            e.manager_id
        FROM LeaveRequest lr
        JOIN Employee e ON lr.employee_id = e.employee_id
        WHERE lr.status = 'Pending'
        AND lr.approval_timing IS NULL
        AND lr.request_id IN (
            SELECT request_id 
            FROM LeaveRequest 
            WHERE approval_timing IS NULL 
            OR approval_timing < @Deadline
        );
 
        DECLARE @RequestID INT, @CurrentManagerID INT, @NextManagerID INT;
        
        DECLARE request_cursor CURSOR FOR
        SELECT RequestID, ManagerID FROM @PendingRequests;
        
        OPEN request_cursor;
        FETCH NEXT FROM request_cursor INTO @RequestID, @CurrentManagerID;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
   
            SELECT @NextManagerID = manager_id 
            FROM Employee 
            WHERE employee_id = @CurrentManagerID 
            AND is_active = 1;
            
            IF @NextManagerID IS NOT NULL
            BEGIN
 
                
                INSERT INTO Notification (message_content, timestamp, urgency, notification_type)
                VALUES (
                    CONCAT('Leave request ', @RequestID, ' escalated to next level manager.'),
                    GETDATE(),
                    'High',
                    'Escalation'
                );
            END
            
            FETCH NEXT FROM request_cursor INTO @RequestID, @CurrentManagerID;
        END
        
        CLOSE request_cursor;
        DEALLOCATE request_cursor;
        
        COMMIT TRANSACTION;
        
        SELECT 'Pending requests escalation completed' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE LinkVacationToShift
    @VacationPackageID INT,
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
        
        DECLARE @VacationShiftID INT;
        
        INSERT INTO ShiftSchedule (name, type, start_time, end_time, status)
        VALUES ('Vacation Package ' + CAST(@VacationPackageID AS VARCHAR), 'Vacation', '00:00', '00:00', 'Active');
        
        SET @VacationShiftID = SCOPE_IDENTITY();

        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, end_date, status)
        VALUES (@EmployeeID, @VacationShiftID, CAST(GETDATE() AS DATE), DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), 'Approved');
        
        SELECT 'Vacation package linked to employee schedule successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ConfigureLeavePolicies
AS
BEGIN
    SET NOCOUNT ON;
 
    
    SELECT 'Leave configuration process initiated successfully' AS Message;
END
GO
 
CREATE PROCEDURE AuthenticateLeaveAdmin
    @AdminID INT,
    @Password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
  
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @AdminID AND is_active = 1)
    BEGIN
        RAISERROR('Admin with ID %d does not exist or is not active.', 16, 1, @AdminID);
        RETURN;
    END
  
    IF NOT EXISTS (
        SELECT 1 FROM Employee_Role er
        JOIN Role r ON er.role_id = r.role_id
        WHERE er.employee_id = @AdminID
        AND (r.role_name LIKE '%HR%' OR r.role_name LIKE '%Leave%' OR r.role_name LIKE '%Admin%')
    )
    BEGIN
        RAISERROR('Employee does not have sufficient privileges for leave management.', 16, 1);
        RETURN;
    END
 
    
    SELECT 'Authentication successful' AS Message;
END
GO
 
CREATE PROCEDURE ApplyLeaveConfiguration
AS
BEGIN
    SET NOCOUNT ON;
 
    
    SELECT 'Leave configuration applied successfully' AS Message;
END
GO
 
CREATE PROCEDURE UpdateLeaveEntitlements
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        DECLARE @HireDate DATE, @TenureMonths INT, @AnnualEntitlement DECIMAL(5,2);
        
        SELECT @HireDate = hire_date FROM Employee WHERE employee_id = @EmployeeID;
        SET @TenureMonths = DATEDIFF(MONTH, @HireDate, GETDATE());
 
        IF @TenureMonths < 12
            SET @AnnualEntitlement = 10.0; -- Pro-rated for first year
        ELSE IF @TenureMonths < 60
            SET @AnnualEntitlement = 20.0; -- 5 years or less
        ELSE
            SET @AnnualEntitlement = 25.0; -- More than 5 years
  
        IF EXISTS (SELECT 1 FROM LeaveEntitlement WHERE employee_id = @EmployeeID AND leave_type_id = 1)
        BEGIN
            UPDATE LeaveEntitlement 
            SET entitlement = @AnnualEntitlement 
            WHERE employee_id = @EmployeeID AND leave_type_id = 1;
        END
        ELSE
        BEGIN
            INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
            VALUES (@EmployeeID, 1, @AnnualEntitlement);
        END
        
        SELECT 
            'Leave entitlements updated successfully' AS Message,
            @AnnualEntitlement AS AnnualEntitlement;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ConfigureLeaveEligibility
    @LeaveType VARCHAR(50),
    @MinTenure INT,
    @EmployeeType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @MinTenure < 0
    BEGIN
        RAISERROR('Minimum tenure cannot be negative.', 16, 1);
        RETURN;
    END
 
    IF @EmployeeType NOT IN ('FullTime', 'PartTime', 'Contractor', 'Temporary')
    BEGIN
        RAISERROR('Invalid employee type. Allowed values: FullTime, PartTime, Contractor, Temporary.', 16, 1);
        RETURN;
    END
    
    
    UPDATE [Leave] 
    SET leave_description = CONCAT('Min Tenure: ', @MinTenure, ' months, Employee Type: ', @EmployeeType)
    WHERE leave_type = @LeaveType;
    
    IF @@ROWCOUNT = 0
    BEGIN
 
        INSERT INTO [Leave] (leave_type, leave_description)
        VALUES (@LeaveType, CONCAT('Min Tenure: ', @MinTenure, ' months, Employee Type: ', @EmployeeType));
    END
    
    SELECT 'Leave eligibility rules configured successfully' AS Message;
END
GO
 
CREATE PROCEDURE ManageLeaveTypes
    @LeaveType VARCHAR(50),
    @Description VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF EXISTS (SELECT 1 FROM [Leave] WHERE leave_type = @LeaveType)
        BEGIN
   
            UPDATE [Leave] 
            SET leave_description = @Description 
            WHERE leave_type = @LeaveType;
            
            SELECT 'Leave type updated successfully' AS Message;
        END
        ELSE
        BEGIN
 
            INSERT INTO [Leave] (leave_type, leave_description)
            VALUES (@LeaveType, @Description);
            
            SELECT 'Leave type created successfully' AS Message;
        END
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE AssignLeaveEntitlement
    @EmployeeID INT,
    @LeaveType VARCHAR(50),
    @Entitlement DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        IF @Entitlement < 0
        BEGIN
            RAISERROR('Leave entitlement cannot be negative.', 16, 1);
            RETURN;
        END
         
        DECLARE @LeaveTypeID INT;
        SELECT @LeaveTypeID = leave_id FROM [Leave] WHERE leave_type = @LeaveType;
        
        IF @LeaveTypeID IS NULL
        BEGIN
            RAISERROR('Leave type %s does not exist.', 16, 1, @LeaveType);
            RETURN;
        END
       
        IF EXISTS (SELECT 1 FROM LeaveEntitlement WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID)
        BEGIN
            UPDATE LeaveEntitlement 
            SET entitlement = @Entitlement 
            WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
        END
        ELSE
        BEGIN
            INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
            VALUES (@EmployeeID, @LeaveTypeID, @Entitlement);
        END
        
        SELECT 'Leave entitlement assigned successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ConfigureLeaveRules
    @LeaveType VARCHAR(50),
    @MaxDuration INT,
    @NoticePeriod INT,
    @WorkflowType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
  
    IF @MaxDuration < 0
    BEGIN
        RAISERROR('Maximum duration cannot be negative.', 16, 1);
        RETURN;
    END
    
    IF @NoticePeriod < 0
    BEGIN
        RAISERROR('Notice period cannot be negative.', 16, 1);
        RETURN;
    END
    
    IF @WorkflowType NOT IN ('ManagerOnly', 'HRApproval', 'AutoApprove', 'MultiLevel')
    BEGIN
        RAISERROR('Invalid workflow type. Allowed values: ManagerOnly, HRApproval, AutoApprove, MultiLevel.', 16, 1);
        RETURN;
    END
    
    DECLARE @NewDescription VARCHAR(500);
    SET @NewDescription = CONCAT('Max Duration: ', @MaxDuration, ' days, Notice Period: ', @NoticePeriod, ' days, Workflow: ', @WorkflowType);
    
    UPDATE [Leave] 
    SET leave_description = @NewDescription 
    WHERE leave_type = @LeaveType;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Leave type %s does not exist.', 16, 1, @LeaveType);
        RETURN;
    END
    
    SELECT 'Leave rules configured successfully' AS Message;
END
GO
 
CREATE PROCEDURE ConfigureSpecialLeave
    @LeaveType VARCHAR(50),
    @Rules VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
 
    IF EXISTS (SELECT 1 FROM [Leave] WHERE leave_type = @LeaveType)
    BEGIN
        UPDATE [Leave] 
        SET leave_description = @Rules 
        WHERE leave_type = @LeaveType;
    END
    ELSE
    BEGIN
        INSERT INTO [Leave] (leave_type, leave_description)
        VALUES (@LeaveType, @Rules);
    END
    
    SELECT 'Special leave type configured successfully' AS Message;
END
GO
 
CREATE PROCEDURE SetLeaveYearRules
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
 
    IF @StartDate >= @EndDate
    BEGIN
        RAISERROR('Start date must be before end date.', 16, 1);
        RETURN;
    END
 
    IF DATEDIFF(MONTH, @StartDate, @EndDate) != 12
    BEGIN
        RAISERROR('Leave year must be exactly 12 months.', 16, 1);
        RETURN;
    END
    
    
    SELECT CONCAT('Leave year set: ', @StartDate, ' to ', @EndDate) AS Message;
END
GO
 
CREATE PROCEDURE AdjustLeaveBalance
    @EmployeeID INT,
    @LeaveType VARCHAR(50),
    @Adjustment DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
  
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee with ID %d does not exist or is not active.', 16, 1, @EmployeeID);
            RETURN;
        END
 
        DECLARE @LeaveTypeID INT;
        SELECT @LeaveTypeID = leave_id FROM [Leave] WHERE leave_type = @LeaveType;
        
        IF @LeaveTypeID IS NULL
        BEGIN
            RAISERROR('Leave type %s does not exist.', 16, 1, @LeaveType);
            RETURN;
        END
 
        DECLARE @CurrentEntitlement DECIMAL(5,2);
        SELECT @CurrentEntitlement = entitlement 
        FROM LeaveEntitlement 
        WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
 
        DECLARE @NewEntitlement DECIMAL(5,2);
        SET @NewEntitlement = ISNULL(@CurrentEntitlement, 0) + @Adjustment;
  
        IF @NewEntitlement < 0
        BEGIN
            RAISERROR('Adjustment would result in negative leave balance.', 16, 1);
            RETURN;
        END
 
        IF EXISTS (SELECT 1 FROM LeaveEntitlement WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID)
        BEGIN
            UPDATE LeaveEntitlement 
            SET entitlement = @NewEntitlement 
            WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
        END
        ELSE
        BEGIN
            INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
            VALUES (@EmployeeID, @LeaveTypeID, @NewEntitlement);
        END
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Leave balance adjusted successfully' AS Message,
            @NewEntitlement AS NewBalance;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ManageLeaveRoles
    @RoleID INT,
    @Permissions VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Role WHERE role_id = @RoleID)
        BEGIN
            RAISERROR('Role with ID %d does not exist.', 16, 1, @RoleID);
            RETURN;
        END 
        DELETE FROM RolePermission WHERE role_id = @RoleID AND permission_name LIKE '%Leave%';
 
        INSERT INTO RolePermission (role_id, permission_name, allowed_action)
        SELECT @RoleID, value, 'Allow'
        FROM STRING_SPLIT(@Permissions, ',');
        
        SELECT 'Leave roles and permissions updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE FinalizeLeaveRequest
    @LeaveRequestID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request with ID %d does not exist.', 16, 1, @LeaveRequestID);
            RETURN;
        END
 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID AND status = 'Approved')
        BEGIN
            RAISERROR('Leave request is not approved and cannot be finalized.', 16, 1);
            RETURN;
        END
 
        DECLARE @CurrentStatus VARCHAR(50);
        SELECT @CurrentStatus = status FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        
        IF @CurrentStatus = 'Finalized'
        BEGIN
            RAISERROR('Leave request is already finalized.', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET status = 'Finalized' 
        WHERE request_id = @LeaveRequestID;
        
        SELECT 'Leave request finalized successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE OverrideLeaveDecision
    @LeaveRequestID INT,
    @Reason VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request with ID %d does not exist.', 16, 1, @LeaveRequestID);
            RETURN;
        END
 
        IF @Reason IS NULL OR LTRIM(RTRIM(@Reason)) = ''
        BEGIN
            RAISERROR('Reason for override must be provided.', 16, 1);
            RETURN;
        END
         
        UPDATE LeaveRequest 
        SET 
            status = CASE WHEN status = 'Approved' THEN 'Rejected' ELSE 'Approved' END,
            approval_timing = GETDATE()
        WHERE request_id = @LeaveRequestID;
        
        SELECT 'Leave decision overridden successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO 
CREATE PROCEDURE BulkProcessLeaveRequests
    @LeaveRequestIDs VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
         
        IF @LeaveRequestIDs IS NULL OR LTRIM(RTRIM(@LeaveRequestIDs)) = ''
        BEGIN
            RAISERROR('No leave request IDs provided.', 16, 1);
            RETURN;
        END
   
        CREATE TABLE #TempRequests (RequestID INT);
  
        INSERT INTO #TempRequests (RequestID)
        SELECT CAST(value AS INT) 
        FROM STRING_SPLIT(@LeaveRequestIDs, ',');
  
        IF EXISTS (
            SELECT 1 FROM #TempRequests tr 
            WHERE NOT EXISTS (SELECT 1 FROM LeaveRequest lr WHERE lr.request_id = tr.RequestID)
        )
        BEGIN
            RAISERROR('One or more leave request IDs do not exist.', 16, 1);
            RETURN;
        END
  
        UPDATE LeaveRequest 
        SET 
            status = 'Approved',
            approval_timing = GETDATE()
        WHERE request_id IN (SELECT RequestID FROM #TempRequests);
        
        DECLARE @ProcessedCount INT = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SELECT CONCAT(@ProcessedCount, ' leave requests processed successfully') AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE VerifyMedicalLeave
    @LeaveRequestID INT,
    @DocumentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request with ID %d does not exist.', 16, 1, @LeaveRequestID);
            RETURN;
        END
         
        IF NOT EXISTS (
            SELECT 1 FROM LeaveRequest lr
            JOIN [Leave] l ON lr.leave_id = l.leave_id
            WHERE lr.request_id = @LeaveRequestID
            AND l.leave_type LIKE '%Medical%'
        )
        BEGIN
            RAISERROR('Leave request is not for medical leave.', 16, 1);
            RETURN;
        END
         
        UPDATE LeaveRequest 
        SET status = 'Verified' 
        WHERE request_id = @LeaveRequestID;
        
        SELECT 'Medical leave documents verified successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE SyncLeaveBalances
    @LeaveRequestID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
    
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID AND status = 'Finalized')
        BEGIN
            RAISERROR('Leave request with ID %d does not exist or is not finalized.', 16, 1, @LeaveRequestID);
            RETURN;
        END
 
        DECLARE @EmployeeID INT, @LeaveTypeID INT, @Duration INT;
        
        SELECT 
            @EmployeeID = employee_id,
            @LeaveTypeID = leave_id,
            @Duration = duration
        FROM LeaveRequest 
        WHERE request_id = @LeaveRequestID;
  
        IF @Duration <= 0
        BEGIN
            RAISERROR('Invalid leave duration.', 16, 1);
            RETURN;
        END
  
        DECLARE @CurrentEntitlement DECIMAL(5,2);
        SELECT @CurrentEntitlement = entitlement 
        FROM LeaveEntitlement 
        WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
 
        DECLARE @NewEntitlement DECIMAL(5,2);
        SET @NewEntitlement = ISNULL(@CurrentEntitlement, 0) - @Duration;
    
        IF @NewEntitlement < 0
        BEGIN
            RAISERROR('Insufficient leave balance for this request.', 16, 1);
            RETURN;
        END
 
        UPDATE LeaveEntitlement 
        SET entitlement = @NewEntitlement 
        WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
        
        IF @@ROWCOUNT = 0
        BEGIN 
            INSERT INTO LeaveEntitlement (employee_id, leave_type_id, entitlement)
            VALUES (@EmployeeID, @LeaveTypeID, @NewEntitlement);
        END
        
        COMMIT TRANSACTION;
        
        SELECT 
            'Leave balances synced successfully' AS Message,
            @NewEntitlement AS RemainingBalance;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ProcessLeaveCarryForward
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
 
        IF @Year < 2000 OR @Year > 2100
        BEGIN
            RAISERROR('Invalid year specified.', 16, 1);
            RETURN;
        END
  
        DECLARE @CarryForwardLimit DECIMAL(5,2) = 10.0; 
        
        UPDATE LeaveEntitlement 
        SET entitlement = 
            CASE 
                WHEN entitlement > @CarryForwardLimit THEN @CarryForwardLimit
                ELSE entitlement
            END
        WHERE leave_type_id IN (SELECT leave_id FROM [Leave] WHERE leave_type = 'Annual')
        AND entitlement > 0;
        
        DECLARE @UpdatedCount INT = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SELECT CONCAT(@UpdatedCount, ' employee leave balances processed for carry-forward') AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE SyncLeaveToAttendance
    @LeaveRequestID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION; 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID AND status = 'Approved')
        BEGIN
            RAISERROR('Leave request with ID %d does not exist or is not approved.', 16, 1, @LeaveRequestID);
            RETURN;
        END
        
  
        DECLARE @EmployeeID INT, @StartDate DATE, @EndDate DATE;
        
        SELECT 
            @EmployeeID = lr.employee_id,
            @StartDate = lr.approval_timing,  
            @EndDate = DATEADD(DAY, lr.duration, lr.approval_timing)
        FROM LeaveRequest lr
        WHERE lr.request_id = @LeaveRequestID;
   
        DECLARE @CurrentDate DATE = @StartDate;
        
        WHILE @CurrentDate <= @EndDate
        BEGIN
      
            IF NOT EXISTS (
                SELECT 1 FROM Attendance 
                WHERE employee_id = @EmployeeID 
                AND CAST(entry_time AS DATE) = @CurrentDate
            )
            BEGIN
 
                INSERT INTO Attendance (employee_id, entry_time, exception_id, login_method)
                VALUES (@EmployeeID, @CurrentDate, 
                       (SELECT exception_id FROM Exception WHERE name = 'Leave' AND category = 'Leave'),
                       'Leave System');
            END
            ELSE
            BEGIN
  
                UPDATE Attendance 
                SET exception_id = (SELECT exception_id FROM Exception WHERE name = 'Leave' AND category = 'Leave')
                WHERE employee_id = @EmployeeID 
                AND CAST(entry_time AS DATE) = @CurrentDate;
            END
            
            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END
        
        COMMIT TRANSACTION;
        
        SELECT 'Leave synchronized with attendance system successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE UpdateInsuranceBrackets
    @BracketID INT,
    @NewMinSalary DECIMAL(10,2),
    @NewMaxSalary DECIMAL(10,2),
    @NewEmployeeContribution DECIMAL(5,2),
    @NewEmployerContribution DECIMAL(5,2),
    @UpdatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @NewMinSalary >= @NewMaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary.', 16, 1);
            RETURN;
        END 
        IF @NewEmployeeContribution < 0 OR @NewEmployerContribution < 0 
           OR @NewEmployeeContribution > 100 OR @NewEmployerContribution > 100
        BEGIN
            RAISERROR('Contribution percentages must be between 0 and 100.', 16, 1);
            RETURN;
        END
   
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @UpdatedBy AND is_active = 1)
        BEGIN
            RAISERROR('Updater with ID %d does not exist or is not active.', 16, 1, @UpdatedBy);
            RETURN;
        END
  
        UPDATE Exception 
        SET 
            name = CONCAT('Insurance Bracket ', @BracketID),
            status = 'Active'
        WHERE exception_id = @BracketID;
        
        IF @@ROWCOUNT = 0
        BEGIN
   
            INSERT INTO Exception (name, category, date, status)
            VALUES (CONCAT('Insurance Bracket ', @BracketID), 'Insurance', GETDATE(), 'Active');
        END
        
        SELECT 'Insurance brackets updated successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
 
CREATE PROCEDURE ApprovePolicyUpdate
    @PolicyID INT,
    @ApprovedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
     
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ApprovedBy AND is_active = 1)
        BEGIN
            RAISERROR('Approver with ID %d does not exist or is not active.', 16, 1, @ApprovedBy);
            RETURN;
        END
        
        IF NOT EXISTS (
            SELECT 1 FROM Employee_Role er
            JOIN Role r ON er.role_id = r.role_id
            WHERE er.employee_id = @ApprovedBy
            AND (r.role_name LIKE '%HR%' OR r.role_name LIKE '%Admin%')
        )
        BEGIN
            RAISERROR('Approver does not have sufficient privileges to approve policy changes.', 16, 1);
            RETURN;
        END
 
        UPDATE Exception 
        SET status = 'Approved' 
        WHERE exception_id = @PolicyID;
        
        SELECT 'Policy update approved successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO 
DROP PROCEDURE IF EXISTS GeneratePayroll;
DROP PROCEDURE IF EXISTS AdjustPayrollItem;
DROP PROCEDURE IF EXISTS CalculateNetSalary;
DROP PROCEDURE IF EXISTS ApplyPayrollPolicy;
DROP PROCEDURE IF EXISTS GetMonthlyPayrollSummary;
DROP PROCEDURE IF EXISTS AddAllowanceDeduction;
DROP PROCEDURE IF EXISTS GetEmployeePayrollHistory;
DROP PROCEDURE IF EXISTS GetBonusEligibleEmployees;
DROP PROCEDURE IF EXISTS UpdateSalaryType;
DROP PROCEDURE IF EXISTS GetPayrollByDepartment;
DROP PROCEDURE IF EXISTS ValidateAttendanceBeforePayroll;
DROP PROCEDURE IF EXISTS SyncAttendanceToPayroll;
DROP PROCEDURE IF EXISTS SyncApprovedPermissionsToPayroll;
DROP PROCEDURE IF EXISTS ConfigurePayGrades;
DROP PROCEDURE IF EXISTS ConfigureShiftAllowances;
DROP PROCEDURE IF EXISTS EnableMultiCurrencyPayroll;
DROP PROCEDURE IF EXISTS ManageTaxRules;
DROP PROCEDURE IF EXISTS ApprovePayrollConfigChanges;
DROP PROCEDURE IF EXISTS ConfigureSigningBonus;
DROP PROCEDURE IF EXISTS ConfigureTerminationBenefits;
DROP PROCEDURE IF EXISTS ConfigureInsuranceBrackets;
DROP PROCEDURE IF EXISTS UpdateInsuranceBrackets;
DROP PROCEDURE IF EXISTS ConfigurePayrollPolicies;
DROP PROCEDURE IF EXISTS DefinePayGrades;
DROP PROCEDURE IF EXISTS ConfigureEscalationWorkflow;
DROP PROCEDURE IF EXISTS DefinePayType;
DROP PROCEDURE IF EXISTS ConfigureOvertimeRules;
DROP PROCEDURE IF EXISTS ConfigureShiftAllowance;
DROP PROCEDURE IF EXISTS ConfigureMultiCurrency;
DROP PROCEDURE IF EXISTS ConfigureSigningBonusPolicy;
DROP PROCEDURE IF EXISTS ConfigureInsuranceBrackets;
DROP PROCEDURE IF EXISTS GenerateTaxStatement;
DROP PROCEDURE IF EXISTS ApprovePayrollConfiguration;
DROP PROCEDURE IF EXISTS ModifyPastPayroll;
GO

 
CREATE PROCEDURE GeneratePayroll
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF EXISTS (SELECT 1 FROM Payroll WHERE period_start = @StartDate AND period_end = @EndDate)
        BEGIN
            RAISERROR('Payroll for this period already exists', 16, 1);
            RETURN;
        END
 
        IF @StartDate >= @EndDate
        BEGIN
            RAISERROR('Start date must be before end date', 16, 1);
            RETURN;
        END 
        INSERT INTO Payroll (employee_id, period_start, period_end, base_amount, net_salary)
        SELECT 
            e.employee_id,
            @StartDate,
            @EndDate,
            ISNULL(pg.min_salary, 0) as base_amount,
            ISNULL(pg.min_salary, 0) as net_salary
        FROM Employee e
        LEFT JOIN PayGrade pg ON e.pay_grade = pg.pay_grade_id
        WHERE e.is_active = 1;
        
        SELECT * FROM Payroll WHERE period_start = @StartDate AND period_end = @EndDate;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE AdjustPayrollItem
    @PayrollID INT,
    @Type VARCHAR(50),
    @Amount DECIMAL(10,2),
    @duration INT = NULL,
    @time_zone VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollID)
        BEGIN
            RAISERROR('Payroll record not found', 16, 1);
            RETURN;
        END
         
        IF @Amount = 0
        BEGIN
            RAISERROR('Amount cannot be zero', 16, 1);
            RETURN;
        END
        
        DECLARE @EmployeeID INT;
        SELECT @EmployeeID = employee_id FROM Payroll WHERE payroll_id = @PayrollID;
        
        INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount, duration, timezone)
        VALUES (@PayrollID, @EmployeeID, @Type, @Amount, @duration, @time_zone);
         
        UPDATE Payroll 
        SET adjustments = adjustments + @Amount,
            net_salary = net_salary + @Amount
        WHERE payroll_id = @PayrollID;
        
        PRINT 'Payroll item adjusted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

 
CREATE PROCEDURE CalculateNetSalary
    @PayrollID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollID)
        BEGIN
            RAISERROR('Payroll record not found', 16, 1);
            RETURN;
        END
        
        DECLARE @NetSalary DECIMAL(10,2);
        
        SELECT @NetSalary = (base_amount + adjustments - taxes - contributions)
        FROM Payroll 
        WHERE payroll_id = @PayrollID;
        
        SELECT @NetSalary AS NetSalary;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ApplyPayrollPolicy
    @PolicyID INT,
    @PayrollID INT,
    @type VARCHAR(20),
    @description VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
         
        IF NOT EXISTS (SELECT 1 FROM PayrollPolicy WHERE policy_id = @PolicyID)
        BEGIN
            RAISERROR('Payroll policy not found', 16, 1);
            RETURN;
        END
   
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollID)
        BEGIN
            RAISERROR('Payroll record not found', 16, 1);
            RETURN;
        END
         
        DECLARE @PolicyAmount DECIMAL(10,2) = 0;
        
        IF @type = 'Bonus'
            SET @PolicyAmount = 500; -- Example bonus amount
        ELSE IF @type = 'Overtime'
            SET @PolicyAmount = 300; -- Example overtime amount
            
        IF @PolicyAmount > 0
        BEGIN
            DECLARE @EmployeeID INT;
            SELECT @EmployeeID = employee_id FROM Payroll WHERE payroll_id = @PayrollID;
            
            INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount)
            VALUES (@PayrollID, @EmployeeID, @type, @PolicyAmount);
            
            UPDATE Payroll 
            SET adjustments = adjustments + @PolicyAmount,
                net_salary = net_salary + @PolicyAmount
            WHERE payroll_id = @PayrollID;
        END
        
        PRINT 'Payroll policy applied successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetMonthlyPayrollSummary
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @Month < 1 OR @Month > 12 OR @Year < 2000 OR @Year > 2100
        BEGIN
            RAISERROR('Invalid month or year', 16, 1);
            RETURN;
        END
        
        SELECT 
            SUM(p.base_amount + p.adjustments - p.taxes - p.contributions) AS TotalExpenditure,
            COUNT(*) AS EmployeeCount,
            AVG(p.base_amount + p.adjustments - p.taxes - p.contributions) AS AverageSalary
        FROM Payroll p
        WHERE MONTH(p.period_start) = @Month AND YEAR(p.period_start) = @Year;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE AddAllowanceDeduction
    @PayrollID INT,
    @Type VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollID)
        BEGIN
            RAISERROR('Payroll record not found', 16, 1);
            RETURN;
        END
 
        IF @Amount = 0
        BEGIN
            RAISERROR('Amount cannot be zero', 16, 1);
            RETURN;
        END
        
        DECLARE @EmployeeID INT;
        SELECT @EmployeeID = employee_id FROM Payroll WHERE payroll_id = @PayrollID;
        
        INSERT INTO AllowanceDeduction (payroll_id, employee_id, type, amount)
        VALUES (@PayrollID, @EmployeeID, @Type, @Amount);
        
        UPDATE Payroll 
        SET adjustments = adjustments + @Amount,
            net_salary = net_salary + @Amount
        WHERE payroll_id = @PayrollID;
        
        PRINT 'Allowance/Deduction added successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetEmployeePayrollHistory
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
   
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            p.payroll_id,
            p.period_start,
            p.period_end,
            p.base_amount,
            p.adjustments,
            p.taxes,
            p.contributions,
            p.net_salary,
            p.payment_date
        FROM Payroll p
        WHERE p.employee_id = @EmployeeID
        ORDER BY p.period_start DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetBonusEligibleEmployees
    @EligibilityCriteria NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        SELECT 
            e.employee_id,
            e.full_name,
            d.department_name,
            p.position_title,
            e.hire_date,
            DATEDIFF(MONTH, e.hire_date, GETDATE()) as tenure_months
        FROM Employee e
        INNER JOIN Department d ON e.department_id = d.department_id
        INNER JOIN Position p ON e.position_id = p.position_id
        WHERE e.is_active = 1 
          AND e.employment_status = 'Active'
          AND DATEDIFF(MONTH, e.hire_date, GETDATE()) >= 6; -- At least 6 months tenure
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE UpdateSalaryType
    @EmployeeID INT,
    @SalaryTypeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
    
        IF NOT EXISTS (SELECT 1 FROM SalaryType WHERE salary_type_id = @SalaryTypeID)
        BEGIN
            RAISERROR('Salary type not found', 16, 1);
            RETURN;
        END
        
        UPDATE Employee 
        SET salary_type_id = @SalaryTypeID 
        WHERE employee_id = @EmployeeID;
        
        PRINT 'Salary type updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetPayrollByDepartment
    @DepartmentID INT,
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
   
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department not found', 16, 1);
            RETURN;
        END
 
        IF @Month < 1 OR @Month > 12 OR @Year < 2000 OR @Year > 2100
        BEGIN
            RAISERROR('Invalid month or year', 16, 1);
            RETURN;
        END
        
        SELECT 
            d.department_name,
            COUNT(p.employee_id) AS EmployeeCount,
            SUM(p.base_amount) AS TotalBaseSalary,
            SUM(p.adjustments) AS TotalAdjustments,
            SUM(p.taxes) AS TotalTaxes,
            SUM(p.net_salary) AS TotalNetSalary
        FROM Payroll p
        INNER JOIN Employee e ON p.employee_id = e.employee_id
        INNER JOIN Department d ON e.department_id = d.department_id
        WHERE d.department_id = @DepartmentID
          AND MONTH(p.period_start) = @Month 
          AND YEAR(p.period_start) = @Year
        GROUP BY d.department_name;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

 
CREATE PROCEDURE ValidateAttendanceBeforePayroll
    @PayrollPeriodID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
   
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollPeriodID)
        BEGIN
            RAISERROR('Payroll period not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            a.attendance_id,
            a.entry_time,
            a.exit_time,
            ex.name AS exception_type
        FROM Employee e
        INNER JOIN Attendance a ON e.employee_id = a.employee_id
        LEFT JOIN Exception ex ON a.exception_id = ex.exception_id
        WHERE a.exception_id IS NOT NULL
          AND e.is_active = 1;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE SyncAttendanceToPayroll
    @SyncDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
    
        IF @SyncDate > GETDATE()
        BEGIN
            RAISERROR('Sync date cannot be in the future', 16, 1);
            RETURN;
        END
         
        UPDATE p
        SET p.adjustments = p.adjustments + 
            (SELECT ISNULL(SUM(ad.amount), 0) 
             FROM AllowanceDeduction ad 
             WHERE ad.employee_id = p.employee_id 
               AND CAST(ad.payroll_id AS DATE) = @SyncDate)
        FROM Payroll p
        WHERE p.period_start <= @SyncDate AND p.period_end >= @SyncDate;
        
        PRINT 'Attendance synced to payroll successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE SyncApprovedPermissionsToPayroll
    @PayrollPeriodID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollPeriodID)
        BEGIN
            RAISERROR('Payroll period not found', 16, 1);
            RETURN;
        END
         
        PRINT 'Approved permissions synced to payroll';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigurePayGrades
    @GradeName VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF EXISTS (SELECT 1 FROM PayGrade WHERE grade_name = @GradeName)
        BEGIN
            RAISERROR('Pay grade with this name already exists', 16, 1);
            RETURN;
        END
         
        IF @MinSalary >= @MaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary', 16, 1);
            RETURN;
        END
        
        INSERT INTO PayGrade (grade_name, min_salary, max_salary)
        VALUES (@GradeName, @MinSalary, @MaxSalary);
        
        PRINT 'Pay grade configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ConfigureShiftAllowances
    @ShiftType VARCHAR(50),
    @AllowanceName VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @Amount <= 0
        BEGIN
            RAISERROR('Allowance amount must be positive', 16, 1);
            RETURN;
        END 
        PRINT 'Shift allowance configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE EnableMultiCurrencyPayroll
    @CurrencyCode VARCHAR(10),
    @ExchangeRate DECIMAL(10,4)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @ExchangeRate <= 0
        BEGIN
            RAISERROR('Exchange rate must be positive', 16, 1);
            RETURN;
        END
         
        UPDATE SalaryType 
        SET currency_code = @CurrencyCode 
        WHERE currency_code IS NULL;
        
        PRINT 'Multi-currency payroll enabled successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ManageTaxRules
    @TaxRuleName VARCHAR(50),
    @CountryCode VARCHAR(10),
    @Rate DECIMAL(5,2),
    @Exemption DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @Rate < 0 OR @Rate > 100
        BEGIN
            RAISERROR('Tax rate must be between 0 and 100', 16, 1);
            RETURN;
        END
         
        PRINT 'Tax rule managed successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ApprovePayrollConfigChanges
    @ConfigID INT,
    @ApproverID INT,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ApproverID AND is_active = 1)
        BEGIN
            RAISERROR('Approver not found or inactive', 16, 1);
            RETURN;
        END
        
        IF @Status NOT IN ('Approved', 'Rejected', 'Pending')
        BEGIN
            RAISERROR('Invalid status. Must be Approved, Rejected, or Pending', 16, 1);
            RETURN;
        END
        
        PRINT 'Payroll configuration change processed successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE ConfigureSigningBonus
    @EmployeeID INT,
    @BonusAmount DECIMAL(10,2),
    @EffectiveDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
  
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
  
        IF @BonusAmount <= 0
        BEGIN
            RAISERROR('Bonus amount must be positive', 16, 1);
            RETURN;
        END
         
        INSERT INTO AllowanceDeduction (employee_id, type, amount)
        VALUES (@EmployeeID, 'Signing Bonus', @BonusAmount);
        
        PRINT 'Signing bonus configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureTerminationBenefits
    @EmployeeID INT,
    @CompensationAmount DECIMAL(10,2),
    @EffectiveDate DATE,
    @Reason VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
         
        IF @CompensationAmount < 0
        BEGIN
            RAISERROR('Compensation amount cannot be negative', 16, 1);
            RETURN;
        END
        
        
        INSERT INTO AllowanceDeduction (employee_id, type, amount)
        VALUES (@EmployeeID, 'Termination Benefits', @CompensationAmount);
        
        PRINT 'Termination benefits configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureInsuranceBrackets
    @InsuranceType VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @EmployeeContribution DECIMAL(5,2),
    @EmployerContribution DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @MinSalary >= @MaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary', 16, 1);
            RETURN;
        END
         
        IF @EmployeeContribution < 0 OR @EmployeeContribution > 100 OR 
           @EmployerContribution < 0 OR @EmployerContribution > 100
        BEGIN
            RAISERROR('Contribution percentages must be between 0 and 100', 16, 1);
            RETURN;
        END
        
        PRINT 'Insurance brackets configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE UpdateInsuranceBrackets
    @BracketID INT,
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @EmployeeContribution DECIMAL(5,2),
    @EmployerContribution DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @MinSalary >= @MaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary', 16, 1);
            RETURN;
        END
         
        IF @EmployeeContribution < 0 OR @EmployeeContribution > 100 OR 
           @EmployerContribution < 0 OR @EmployerContribution > 100
        BEGIN
            RAISERROR('Contribution percentages must be between 0 and 100', 16, 1);
            RETURN;
        END
        
        PRINT 'Insurance brackets updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ConfigurePayrollPolicies
    @PolicyType VARCHAR(50),
    @PolicyDetails NVARCHAR(MAX),
    @effectivedate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF EXISTS (SELECT 1 FROM PayrollPolicy WHERE type = @PolicyType AND effective_date = @effectivedate)
        BEGIN
            RAISERROR('Policy for this type and date already exists', 16, 1);
            RETURN;
        END
        
        INSERT INTO PayrollPolicy (type, description, effective_date)
        VALUES (@PolicyType, @PolicyDetails, @effectivedate);
        
        PRINT 'Payroll policy configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE DefinePayGrades
    @GradeName VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
     
        IF EXISTS (SELECT 1 FROM PayGrade WHERE grade_name = @GradeName)
        BEGIN
            RAISERROR('Pay grade with this name already exists', 16, 1);
            RETURN;
        END
         
        IF @MinSalary >= @MaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary', 16, 1);
            RETURN;
        END
        
        INSERT INTO PayGrade (grade_name, min_salary, max_salary)
        VALUES (@GradeName, @MinSalary, @MaxSalary);
        
        PRINT 'Pay grade defined successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureEscalationWorkflow
    @ThresholdAmount DECIMAL(10,2),
    @ApproverRole VARCHAR(50),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @ThresholdAmount <= 0
        BEGIN
            RAISERROR('Threshold amount must be positive', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @CreatedBy)
        BEGIN
            RAISERROR('Creator not found', 16, 1);
            RETURN;
        END
        
        PRINT 'Escalation workflow configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE DefinePayType
    @EmployeeID INT,
    @PayType VARCHAR(50),
    @EffectiveDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END 
        IF @PayType NOT IN ('Hourly', 'Daily', 'Monthly', 'Weekly')
        BEGIN
            RAISERROR('Invalid pay type. Must be Hourly, Daily, Monthly, or Weekly', 16, 1);
            RETURN;
        END
         
        DECLARE @SalaryTypeID INT;
        
        IF EXISTS (SELECT 1 FROM SalaryType WHERE type = @PayType)
        BEGIN
            SELECT @SalaryTypeID = salary_type_id FROM SalaryType WHERE type = @PayType;
        END
        ELSE
        BEGIN
            INSERT INTO SalaryType (type, payment_frequency) 
            VALUES (@PayType, @PayType);
            SET @SalaryTypeID = SCOPE_IDENTITY();
        END
        
        UPDATE Employee SET salary_type_id = @SalaryTypeID WHERE employee_id = @EmployeeID;
        
        PRINT 'Pay type defined successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureOvertimeRules
    @DayType VARCHAR(20),
    @Multiplier DECIMAL(3,2),
    @hourspermonth INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF @Multiplier <= 0
        BEGIN
            RAISERROR('Multiplier must be positive', 16, 1);
            RETURN;
        END
         
        IF @hourspermonth < 0 OR @hourspermonth > 200
        BEGIN
            RAISERROR('Hours per month must be between 0 and 200', 16, 1);
            RETURN;
        END
        
        PRINT 'Overtime rules configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureShiftAllowance
    @ShiftType VARCHAR(20),
    @AllowanceAmount DECIMAL(10,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @AllowanceAmount <= 0
        BEGIN
            RAISERROR('Allowance amount must be positive', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @CreatedBy)
        BEGIN
            RAISERROR('Creator not found', 16, 1);
            RETURN;
        END
        
        PRINT 'Shift allowance configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ConfigureMultiCurrency
    @CurrencyCode VARCHAR(10),
    @ExchangeRate DECIMAL(10,4),
    @EffectiveDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @ExchangeRate <= 0
        BEGIN
            RAISERROR('Exchange rate must be positive', 16, 1);
            RETURN;
        END 
        UPDATE SalaryType 
        SET currency_code = @CurrencyCode 
        WHERE currency_code IS NULL;
        
        PRINT 'Multi-currency configuration updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ConfigureSigningBonusPolicy
    @BonusType VARCHAR(50),
    @Amount DECIMAL(10,2),
    @EligibilityCriteria NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @Amount <= 0
        BEGIN
            RAISERROR('Bonus amount must be positive', 16, 1);
            RETURN;
        END
         
        INSERT INTO PayrollPolicy (type, description, effective_date)
        VALUES (@BonusType, @EligibilityCriteria, GETDATE());
        
        PRINT 'Signing bonus policy configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ConfigureInsuranceBrackets
    @BracketName VARCHAR(50),
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2),
    @EmployeeContribut DECIMAL(5,2),
    @EmployerContribution DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @MinSalary >= @MaxSalary
        BEGIN
            RAISERROR('Minimum salary must be less than maximum salary', 16, 1);
            RETURN;
        END
         
        IF @EmployeeContribut < 0 OR @EmployeeContribut > 100 OR 
           @EmployerContribution < 0 OR @EmployerContribution > 100
        BEGIN
            RAISERROR('Contribution percentages must be between 0 and 100', 16, 1);
            RETURN;
        END
        
        PRINT 'Insurance brackets configured successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GenerateTaxStatement
    @EmployeeID INT,
    @TaxYear INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
         
        IF @TaxYear < 2000 OR @TaxYear > YEAR(GETDATE())
        BEGIN
            RAISERROR('Invalid tax year', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.full_name,
            e.national_id,
            SUM(p.base_amount) AS TotalIncome,
            SUM(p.taxes) AS TotalTaxes,
            SUM(p.contributions) AS TotalContributions,
            SUM(p.net_salary) AS NetIncome
        FROM Employee e
        INNER JOIN Payroll p ON e.employee_id = p.employee_id
        WHERE e.employee_id = @EmployeeID 
          AND YEAR(p.period_start) = @TaxYear
        GROUP BY e.full_name, e.national_id;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ApprovePayrollConfiguration
    @ConfigID INT,
    @ApprovedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ApprovedBy AND is_active = 1)
        BEGIN
            RAISERROR('Approver not found or inactive', 16, 1);
            RETURN;
        END
        
        PRINT 'Payroll configuration approved successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ModifyPastPayroll
    @PayrollRunID INT,
    @EmployeeID INT,
    @FieldName VARCHAR(50),
    @NewValue DECIMAL(10,2),
    @ModifiedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Payroll WHERE payroll_id = @PayrollRunID)
        BEGIN
            RAISERROR('Payroll run not found', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ModifiedBy)
        BEGIN
            RAISERROR('Modifier not found', 16, 1);
            RETURN;
        END
         
        IF @FieldName NOT IN ('base_amount', 'adjustments', 'taxes', 'contributions')
        BEGIN
            RAISERROR('Invalid field name', 16, 1);
            RETURN;
        END
         
        DECLARE @SQL NVARCHAR(1000);
        SET @SQL = 'UPDATE Payroll SET ' + @FieldName + ' = @NewValue WHERE payroll_id = @PayrollRunID AND employee_id = @EmployeeID';
        
        EXEC sp_executesql @SQL, 
            N'@NewValue DECIMAL(10,2), @PayrollRunID INT, @EmployeeID INT',
            @NewValue, @PayrollRunID, @EmployeeID;
         
        INSERT INTO Payroll_Log (payroll_id, actor, modification_type)
        VALUES (@PayrollRunID, @ModifiedBy, 'Modified ' + @FieldName);
        
        PRINT 'Past payroll modified successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT 'All Payroll Officer procedures created successfully';  
DROP PROCEDURE IF EXISTS ReviewLeaveRequest;
DROP PROCEDURE IF EXISTS AssignShift;
DROP PROCEDURE IF EXISTS ViewTeamAttendance;
DROP PROCEDURE IF EXISTS SendTeamNotification;
DROP PROCEDURE IF EXISTS ApproveMissionCompletion;
DROP PROCEDURE IF EXISTS RequestReplacement;
DROP PROCEDURE IF EXISTS ViewDepartmentSummary;
DROP PROCEDURE IF EXISTS ReassignShift;
DROP PROCEDURE IF EXISTS GetPendingLeaveRequests;
DROP PROCEDURE IF EXISTS GetTeamStatistics;
DROP PROCEDURE IF EXISTS ViewTeamProfiles;
DROP PROCEDURE IF EXISTS GetTeamSummary;
DROP PROCEDURE IF EXISTS FilterTeamProfiles;
DROP PROCEDURE IF EXISTS ViewTeamCertifications;
DROP PROCEDURE IF EXISTS AddManagerNotes;
DROP PROCEDURE IF EXISTS RecordManualAttendance;
DROP PROCEDURE IF EXISTS ReviewMissedPunches;
DROP PROCEDURE IF EXISTS ApproveTimeRequest;
DROP PROCEDURE IF EXISTS ViewLeaveRequest;
DROP PROCEDURE IF EXISTS ApproveLeaveRequest;
DROP PROCEDURE IF EXISTS RejectLeaveRequest;
DROP PROCEDURE IF EXISTS DelegateLeaveApproval;
DROP PROCEDURE IF EXISTS FlagIrregularLeave;
DROP PROCEDURE IF EXISTS NotifyNewLeaveRequest;
GO 
CREATE PROCEDURE ReviewLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
       
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END
        
       
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND is_active = 1)
        BEGIN
            RAISERROR('Manager not found or inactive', 16, 1);
            RETURN;
        END
         
        IF @Decision NOT IN ('Approved', 'Rejected', 'Pending')
        BEGIN
            RAISERROR('Invalid decision. Must be Approved, Rejected, or Pending', 16, 1);
            RETURN;
        END
         
        DECLARE @EmployeeID INT, @EmployeeManagerID INT;
        SELECT @EmployeeID = employee_id FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        SELECT @EmployeeManagerID = manager_id FROM Employee WHERE employee_id = @EmployeeID;
        
        IF @EmployeeManagerID != @ManagerID
        BEGIN
            RAISERROR('Manager is not authorized to approve this leave request', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET status = @Decision, 
            approval_timing = GETDATE()
        WHERE request_id = @LeaveRequestID;
        
        SELECT @LeaveRequestID AS LeaveRequestID, @ManagerID AS ManagerID, @Decision AS Decision;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE AssignShift
    @EmployeeID INT,
    @ShiftID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @ShiftID)
        BEGIN
            RAISERROR('Shift not found', 16, 1);
            RETURN;
        END
         
        IF EXISTS (SELECT 1 FROM ShiftAssignment WHERE employee_id = @EmployeeID AND shift_id = @ShiftID AND status = 'Active')
        BEGIN
            RAISERROR('Employee already has this shift assignment', 16, 1);
            RETURN;
        END
        
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, status)
        VALUES (@EmployeeID, @ShiftID, GETDATE(), 'Active');
        
        PRINT 'Shift assigned successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewTeamAttendance
    @ManagerID INT,
    @DateRangeStart DATE,
    @DateRangeEnd DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END 
        IF @DateRangeStart > @DateRangeEnd
        BEGIN
            RAISERROR('Start date must be before end date', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            a.entry_time,
            a.exit_time,
            a.duration,
            ex.name AS exception_type,
            a.login_method,
            a.logout_method
        FROM Employee e
        INNER JOIN Attendance a ON e.employee_id = a.employee_id
        LEFT JOIN Exception ex ON a.exception_id = ex.exception_id
        WHERE e.manager_id = @ManagerID
          AND CAST(a.entry_time AS DATE) BETWEEN @DateRangeStart AND @DateRangeEnd
        ORDER BY e.employee_id, a.entry_time;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE SendTeamNotification
    @ManagerID INT,
    @MessageContent VARCHAR(255),
    @UrgencyLevel VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
      
        IF @UrgencyLevel NOT IN ('Low', 'Medium', 'High', 'Critical')
        BEGIN
            RAISERROR('Invalid urgency level. Must be Low, Medium, High, or Critical', 16, 1);
            RETURN;
        END 
        IF LEN(@MessageContent) = 0
        BEGIN
            RAISERROR('Message content cannot be empty', 16, 1);
            RETURN;
        END
    
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, urgency, notification_type)
        VALUES (@MessageContent, @UrgencyLevel, 'Team Notification');
        
        SET @NotificationID = SCOPE_IDENTITY();
         
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        SELECT employee_id, @NotificationID, 'Pending'
        FROM Employee 
        WHERE manager_id = @ManagerID AND is_active = 1;
        
        PRINT 'Team notification sent successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ApproveMissionCompletion
    @MissionID INT,
    @ManagerID INT,
    @Remarks VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Mission WHERE mission_id = @MissionID)
        BEGIN
            RAISERROR('Mission not found', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Mission WHERE mission_id = @MissionID AND manager_id = @ManagerID)
        BEGIN
            RAISERROR('Manager is not assigned to this mission or does not exist', 16, 1);
            RETURN;
        END
        
        UPDATE Mission 
        SET status = 'Completed',
            end_date = GETDATE()
        WHERE mission_id = @MissionID;
        
        PRINT 'Mission completion approved successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE RequestReplacement
    @EmployeeID INT,
    @Reason VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
         
        IF LEN(@Reason) = 0
        BEGIN
            RAISERROR('Reason cannot be empty', 16, 1);
            RETURN;
        END
         
        PRINT 'Replacement request submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewDepartmentSummary
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Department WHERE department_id = @DepartmentID)
        BEGIN
            RAISERROR('Department not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            d.department_name,
            COUNT(e.employee_id) AS EmployeeCount,
            SUM(CASE WHEN e.is_active = 1 THEN 1 ELSE 0 END) AS ActiveEmployees,
            AVG(pg.min_salary) AS AverageSalary,
            d.purpose
        FROM Department d
        LEFT JOIN Employee e ON d.department_id = e.department_id
        LEFT JOIN PayGrade pg ON e.pay_grade = pg.pay_grade_id
        WHERE d.department_id = @DepartmentID
        GROUP BY d.department_name, d.purpose;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ReassignShift
    @EmployeeID INT,
    @OldShiftID INT,
    @NewShiftID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM ShiftAssignment WHERE employee_id = @EmployeeID AND shift_id = @OldShiftID AND status = 'Active')
        BEGIN
            RAISERROR('Current shift assignment not found', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @NewShiftID)
        BEGIN
            RAISERROR('New shift not found', 16, 1);
            RETURN;
        END
         
        UPDATE ShiftAssignment 
        SET status = 'Reassigned', 
            end_date = GETDATE()
        WHERE employee_id = @EmployeeID AND shift_id = @OldShiftID AND status = 'Active';
         
        INSERT INTO ShiftAssignment (employee_id, shift_id, start_date, status)
        VALUES (@EmployeeID, @NewShiftID, GETDATE(), 'Active');
        
        PRINT 'Shift reassigned successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetPendingLeaveRequests
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            lr.request_id,
            e.employee_id,
            e.full_name,
            l.leave_type,
            lr.justification,
            lr.duration,
            lr.status
        FROM LeaveRequest lr
        INNER JOIN Employee e ON lr.employee_id = e.employee_id
        INNER JOIN [Leave] l ON lr.leave_id = l.leave_id
        WHERE e.manager_id = @ManagerID 
          AND lr.status = 'Pending'
        ORDER BY lr.request_id;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetTeamStatistics
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            COUNT(e.employee_id) AS TeamSize,
            AVG(pg.min_salary) AS AverageSalary,
            COUNT(DISTINCT e.department_id) AS DepartmentsManaged,
            MIN(e.hire_date) AS OldestTeamMember,
            MAX(e.hire_date) AS NewestTeamMember
        FROM Employee e
        LEFT JOIN PayGrade pg ON e.pay_grade = pg.pay_grade_id
        WHERE e.manager_id = @ManagerID AND e.is_active = 1;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewTeamProfiles
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            e.email,
            e.phone,
            p.position_title,
            d.department_name,
            e.hire_date,
            e.employment_status
        FROM Employee e
        INNER JOIN Position p ON e.position_id = p.position_id
        INNER JOIN Department d ON e.department_id = d.department_id
        WHERE e.manager_id = @ManagerID AND e.is_active = 1
        ORDER BY e.full_name;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetTeamSummary
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            p.position_title,
            COUNT(e.employee_id) AS EmployeeCount,
            AVG(DATEDIFF(MONTH, e.hire_date, GETDATE())) AS AverageTenureMonths,
            d.department_name
        FROM Employee e
        INNER JOIN Position p ON e.position_id = p.position_id
        INNER JOIN Department d ON e.department_id = d.department_id
        WHERE e.manager_id = @ManagerID AND e.is_active = 1
        GROUP BY p.position_title, d.department_name
        ORDER BY EmployeeCount DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE FilterTeamProfiles
    @ManagerID INT,
    @Skill VARCHAR(50) = NULL,
    @RoleID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT DISTINCT
            e.employee_id,
            e.full_name,
            p.position_title,
            d.department_name,
            s.skill_name,
            r.role_name
        FROM Employee e
        INNER JOIN Position p ON e.position_id = p.position_id
        INNER JOIN Department d ON e.department_id = d.department_id
        LEFT JOIN Employee_Skill es ON e.employee_id = es.employee_id
        LEFT JOIN Skill s ON es.skill_id = s.skill_id
        LEFT JOIN Employee_Role er ON e.employee_id = er.employee_id
        LEFT JOIN Role r ON er.role_id = r.role_id
        WHERE e.manager_id = @ManagerID 
          AND e.is_active = 1
          AND (@Skill IS NULL OR s.skill_name LIKE '%' + @Skill + '%')
          AND (@RoleID IS NULL OR er.role_id = @RoleID)
        ORDER BY e.full_name;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewTeamCertifications
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            v.verification_type,
            v.issuer,
            v.issue_date,
            v.expiry_period,
            s.skill_name,
            es.proficiency_level
        FROM Employee e
        LEFT JOIN Employee_Verification ev ON e.employee_id = ev.employee_id
        LEFT JOIN Verification v ON ev.verification_id = v.verification_id
        LEFT JOIN Employee_Skill es ON e.employee_id = es.employee_id
        LEFT JOIN Skill s ON es.skill_id = s.skill_id
        WHERE e.manager_id = @ManagerID AND e.is_active = 1
        ORDER BY e.full_name, v.verification_type;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE AddManagerNotes
    @EmployeeID INT,
    @ManagerID INT,
    @Note VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID AND employee_id IN 
                      (SELECT manager_id FROM Employee WHERE employee_id = @EmployeeID))
        BEGIN
            RAISERROR('Manager is not authorized to add notes for this employee', 16, 1);
            RETURN;
        END
         
        IF LEN(@Note) = 0
        BEGIN
            RAISERROR('Note content cannot be empty', 16, 1);
            RETURN;
        END
        
        INSERT INTO ManagerNotes (employee_id, manager_id, note_content)
        VALUES (@EmployeeID, @ManagerID, @Note);
        
        PRINT 'Manager note added successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE RecordManualAttendance
    @EmployeeID INT,
    @Date DATE,
    @ClockIn TIME,
    @ClockOut TIME,
    @Reason VARCHAR(200),
    @RecordedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @RecordedBy)
        BEGIN
            RAISERROR('Recorder not found', 16, 1);
            RETURN;
        END
         
        IF @ClockIn >= @ClockOut
        BEGIN
            RAISERROR('Clock-in time must be before clock-out time', 16, 1);
            RETURN;
        END
         
        IF EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @Date)
        BEGIN
            RAISERROR('Attendance record already exists for this date', 16, 1);
            RETURN;
        END 
        DECLARE @Duration INT = DATEDIFF(MINUTE, @ClockIn, @ClockOut);
        
        INSERT INTO Attendance (employee_id, entry_time, exit_time, duration, login_method, logout_method)
        VALUES (@EmployeeID, 
                CAST(@Date AS DATETIME) + CAST(@ClockIn AS DATETIME), 
                CAST(@Date AS DATETIME) + CAST(@ClockOut AS DATETIME), 
                @Duration, 'Manual', 'Manual');
         
        DECLARE @AttendanceID INT = SCOPE_IDENTITY();
        
        INSERT INTO AttendanceLog (attendance_id, actor, reason)
        VALUES (@AttendanceID, @RecordedBy, @Reason);
        
        PRINT 'Manual attendance recorded successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ReviewMissedPunches
    @ManagerID INT,
    @Date DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            a.attendance_id,
            a.entry_time,
            a.exit_time,
            ex.name AS exception_type,
            ex.category
        FROM Employee e
        INNER JOIN Attendance a ON e.employee_id = a.employee_id
        INNER JOIN Exception ex ON a.exception_id = ex.exception_id
        WHERE e.manager_id = @ManagerID
          AND CAST(a.entry_time AS DATE) = @Date
          AND ex.category IN ('Missed Punch', 'Incomplete Attendance')
        ORDER BY e.employee_id;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ApproveTimeRequest
    @RequestID INT,
    @ManagerID INT,
    @Decision VARCHAR(20),
    @Comments VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF @RequestID <= 0
        BEGIN
            RAISERROR('Time request not found', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
         
        IF @Decision NOT IN ('Approved', 'Rejected')
        BEGIN
            RAISERROR('Invalid decision. Must be Approved or Rejected', 16, 1);
            RETURN;
        END
        
        PRINT 'Time request processed successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END 
        DECLARE @EmployeeID INT, @EmployeeManagerID INT;
        SELECT @EmployeeID = employee_id FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        SELECT @EmployeeManagerID = manager_id FROM Employee WHERE employee_id = @EmployeeID;
        
        IF @EmployeeManagerID != @ManagerID
        BEGIN
            RAISERROR('Manager is not authorized to view this leave request', 16, 1);
            RETURN;
        END
        
        SELECT 
            lr.request_id,
            e.employee_id,
            e.full_name,
            l.leave_type,
            lr.justification,
            lr.duration,
            lr.status,
            lr.approval_timing,
            ld.file_path
        FROM LeaveRequest lr
        INNER JOIN Employee e ON lr.employee_id = e.employee_id
        INNER JOIN [Leave] l ON lr.leave_id = l.leave_id
        LEFT JOIN LeaveDocument ld ON lr.request_id = ld.leave_request_id
        WHERE lr.request_id = @LeaveRequestID;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ApproveLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END 
        DECLARE @EmployeeID INT, @EmployeeManagerID INT;
        SELECT @EmployeeID = employee_id FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        SELECT @EmployeeManagerID = manager_id FROM Employee WHERE employee_id = @EmployeeID;
        
        IF @EmployeeManagerID != @ManagerID
        BEGIN
            RAISERROR('Manager is not authorized to approve this leave request', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET status = 'Approved', 
            approval_timing = GETDATE()
        WHERE request_id = @LeaveRequestID;
        
        PRINT 'Leave request approved successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

 
CREATE PROCEDURE RejectLeaveRequest
    @LeaveRequestID INT,
    @ManagerID INT,
    @Reason VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END
         
        DECLARE @EmployeeID INT, @EmployeeManagerID INT;
        SELECT @EmployeeID = employee_id FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        SELECT @EmployeeManagerID = manager_id FROM Employee WHERE employee_id = @EmployeeID;
        
        IF @EmployeeManagerID != @ManagerID
        BEGIN
            RAISERROR('Manager is not authorized to reject this leave request', 16, 1);
            RETURN;
        END
         
        IF LEN(@Reason) = 0
        BEGIN
            RAISERROR('Rejection reason cannot be empty', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET status = 'Rejected', 
            approval_timing = GETDATE(),
            justification = justification + ' - Rejection Reason: ' + @Reason
        WHERE request_id = @LeaveRequestID;
        
        PRINT 'Leave request rejected successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE DelegateLeaveApproval
    @ManagerID INT,
    @DelegateID INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END
         
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @DelegateID AND manager_id = @ManagerID)
        BEGIN
            RAISERROR('Delegate must be a subordinate of the manager', 16, 1);
            RETURN;
        END 
        IF @StartDate >= @EndDate
        BEGIN
            RAISERROR('Start date must be before end date', 16, 1);
            RETURN;
        END
         
        PRINT 'Leave approval authority delegated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE FlagIrregularLeave
    @EmployeeID INT,
    @ManagerID INT,
    @PatternDescription VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND manager_id = @ManagerID)
        BEGIN
            RAISERROR('Employee not found or not managed by this manager', 16, 1);
            RETURN;
        END
         
        IF LEN(@PatternDescription) = 0
        BEGIN
            RAISERROR('Pattern description cannot be empty', 16, 1);
            RETURN;
        END 
        INSERT INTO ManagerNotes (employee_id, manager_id, note_content)
        VALUES (@EmployeeID, @ManagerID, 'Irregular Leave Pattern: ' + @PatternDescription);
        
        PRINT 'Irregular leave pattern flagged successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE NotifyNewLeaveRequest
    @ManagerID INT,
    @RequestID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @ManagerID)
        BEGIN
            RAISERROR('Manager not found', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @RequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END
         
        DECLARE @EmployeeID INT, @EmployeeName VARCHAR(200);
        SELECT @EmployeeID = lr.employee_id, @EmployeeName = e.full_name
        FROM LeaveRequest lr
        INNER JOIN Employee e ON lr.employee_id = e.employee_id
        WHERE lr.request_id = @RequestID;
        
        DECLARE @MessageContent VARCHAR(255) = 'New leave request from ' + @EmployeeName;
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, urgency, notification_type)
        VALUES (@MessageContent, 'Medium', 'Leave Request');
        
        SET @NotificationID = SCOPE_IDENTITY();
        
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        VALUES (@ManagerID, @NotificationID, 'Pending');
        
        SELECT @NotificationID AS NotificationID, @MessageContent AS MessageContent;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT 'All Line Manager procedures created successfully';
  
DROP PROCEDURE IF EXISTS SubmitLeaveRequest;
DROP PROCEDURE IF EXISTS GetLeaveBalance;
DROP PROCEDURE IF EXISTS RecordAttendance;
DROP PROCEDURE IF EXISTS SubmitReimbursement;
DROP PROCEDURE IF EXISTS AddEmployeeSkill;
DROP PROCEDURE IF EXISTS ViewAssignedShifts;
DROP PROCEDURE IF EXISTS ViewMyContracts;
DROP PROCEDURE IF EXISTS ViewMyPayroll;
DROP PROCEDURE IF EXISTS UpdatePersonalDetails;
DROP PROCEDURE IF EXISTS ViewMyMissions;
DROP PROCEDURE IF EXISTS ViewEmployeeProfile;
DROP PROCEDURE IF EXISTS UpdateContactInformation;
DROP PROCEDURE IF EXISTS ViewEmploymentTimeline;
DROP PROCEDURE IF EXISTS UpdateEmergencyContact;
DROP PROCEDURE IF EXISTS RequestHRDocument;
DROP PROCEDURE IF EXISTS NotifyProfileUpdate;
DROP PROCEDURE IF EXISTS LogFlexibleAttendance;
DROP PROCEDURE IF EXISTS NotifyMissedPunch;
DROP PROCEDURE IF EXISTS RecordMultiplePunches;
DROP PROCEDURE IF EXISTS SubmitCorrectionRequest;
DROP PROCEDURE IF EXISTS ViewRequestStatus;
DROP PROCEDURE IF EXISTS AttachLeaveDocuments;
DROP PROCEDURE IF EXISTS ModifyLeaveRequest;
DROP PROCEDURE IF EXISTS CancelLeaveRequest;
DROP PROCEDURE IF EXISTS ViewLeaveBalance;
DROP PROCEDURE IF EXISTS ViewLeaveHistory;
DROP PROCEDURE IF EXISTS SubmitLeaveAfterAbsence;
DROP PROCEDURE IF EXISTS NotifyLeaveStatusChange;
GO
 
CREATE PROCEDURE SubmitLeaveRequest
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM [Leave] WHERE leave_id = @LeaveTypeID)
        BEGIN
            RAISERROR('Leave type not found', 16, 1);
            RETURN;
        END
  
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date must be before end date', 16, 1);
            RETURN;
        END
         
        IF @StartDate < CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Leave cannot start in the past', 16, 1);
            RETURN;
        END
   
        DECLARE @AvailableBalance DECIMAL(6,2);
        SELECT @AvailableBalance = entitlement 
        FROM LeaveEntitlement 
        WHERE employee_id = @EmployeeID AND leave_type_id = @LeaveTypeID;
        
        IF @AvailableBalance IS NULL OR @AvailableBalance <= 0
        BEGIN
            RAISERROR('Insufficient leave balance', 16, 1);
            RETURN;
        END
        
        DECLARE @Duration INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
        
        IF @Duration > @AvailableBalance
        BEGIN
            RAISERROR('Requested leave duration exceeds available balance', 16, 1);
            RETURN;
        END
        
        INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, status)
        VALUES (@EmployeeID, @LeaveTypeID, @Reason, @Duration, 'Pending');
        
        PRINT 'Leave request submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE GetLeaveBalance
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
    
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            l.leave_type,
            le.entitlement AS TotalEntitlement,
            ISNULL(SUM(CASE WHEN lr.status = 'Approved' THEN lr.duration ELSE 0 END), 0) AS UsedDays,
            (le.entitlement - ISNULL(SUM(CASE WHEN lr.status = 'Approved' THEN lr.duration ELSE 0 END), 0)) AS RemainingDays
        FROM LeaveEntitlement le
        INNER JOIN [Leave] l ON le.leave_type_id = l.leave_id
        LEFT JOIN LeaveRequest lr ON le.employee_id = lr.employee_id AND le.leave_type_id = lr.leave_id
        WHERE le.employee_id = @EmployeeID
        GROUP BY l.leave_type, le.entitlement;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE RecordAttendance
    @EmployeeID INT,
    @ShiftID INT,
    @EntryTime TIME,
    @ExitTime TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM ShiftSchedule WHERE shift_id = @ShiftID)
        BEGIN
            RAISERROR('Shift not found', 16, 1);
            RETURN;
        END
         
        IF @EntryTime >= @ExitTime
        BEGIN
            RAISERROR('Entry time must be before exit time', 16, 1);
            RETURN;
        END 
        IF EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = CAST(GETDATE() AS DATE))
        BEGIN
            RAISERROR('Attendance already recorded for today', 16, 1);
            RETURN;
        END
        
        DECLARE @Duration INT = DATEDIFF(MINUTE, @EntryTime, @ExitTime);
        
        INSERT INTO Attendance (employee_id, shift_id, entry_time, exit_time, duration, login_method, logout_method)
        VALUES (@EmployeeID, @ShiftID, 
                CAST(GETDATE() AS DATETIME) + CAST(@EntryTime AS DATETIME), 
                CAST(GETDATE() AS DATETIME) + CAST(@ExitTime AS DATETIME), 
                @Duration, 'Manual', 'Manual');
        
        PRINT 'Attendance recorded successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE SubmitReimbursement
    @EmployeeID INT,
    @ExpenseType VARCHAR(50),
    @Amount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
 
        IF @Amount <= 0
        BEGIN
            RAISERROR('Amount must be positive', 16, 1);
            RETURN;
        END
         
        IF LEN(@ExpenseType) = 0
        BEGIN
            RAISERROR('Expense type cannot be empty', 16, 1);
            RETURN;
        END
        
        INSERT INTO Reimbursement (employee_id, type, claim_type, current_status, amount)
        VALUES (@EmployeeID, @ExpenseType, @ExpenseType, 'Submitted', @Amount);
        
        PRINT 'Reimbursement request submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE AddEmployeeSkill
    @EmployeeID INT,
    @SkillName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF LEN(@SkillName) = 0
        BEGIN
            RAISERROR('Skill name cannot be empty', 16, 1);
            RETURN;
        END
        
        DECLARE @SkillID INT;
         
        IF EXISTS (SELECT 1 FROM Skill WHERE skill_name = @SkillName)
        BEGIN
            SELECT @SkillID = skill_id FROM Skill WHERE skill_name = @SkillName;
        END
        ELSE
        BEGIN 
            INSERT INTO Skill (skill_name) VALUES (@SkillName);
            SET @SkillID = SCOPE_IDENTITY();
        END
         
        IF EXISTS (SELECT 1 FROM Employee_Skill WHERE employee_id = @EmployeeID AND skill_id = @SkillID)
        BEGIN
            RAISERROR('Employee already has this skill', 16, 1);
            RETURN;
        END
        
        INSERT INTO Employee_Skill (employee_id, skill_id, proficiency_level)
        VALUES (@EmployeeID, @SkillID, 1); -- Default proficiency level 1
        
        PRINT 'Employee skill added successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewAssignedShifts
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            sa.assignment_id,
            ss.name AS shift_name,
            ss.type AS shift_type,
            ss.start_time,
            ss.end_time,
            sa.start_date,
            sa.end_date,
            sa.status
        FROM ShiftAssignment sa
        INNER JOIN ShiftSchedule ss ON sa.shift_id = ss.shift_id
        WHERE sa.employee_id = @EmployeeID
          AND sa.status = 'Active'
          AND (sa.end_date IS NULL OR sa.end_date >= CAST(GETDATE() AS DATE))
        ORDER BY sa.start_date, ss.start_time;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewMyContracts
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            c.contract_id,
            c.type,
            c.start_date,
            c.end_date,
            c.current_state,
            ftc.leave_entitlement,
            ftc.weekly_working_hours,
            ptc.working_hours,
            ptc.hourly_rate
        FROM Employee e
        INNER JOIN Contract c ON e.contract_id = c.contract_id
        LEFT JOIN FullTimeContract ftc ON c.contract_id = ftc.contract_id
        LEFT JOIN PartTimeContract ptc ON c.contract_id = ptc.contract_id
        WHERE e.employee_id = @EmployeeID
        ORDER BY c.start_date DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewMyPayroll
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            payroll_id,
            period_start,
            period_end,
            base_amount,
            adjustments,
            taxes,
            contributions,
            net_salary,
            payment_date
        FROM Payroll
        WHERE employee_id = @EmployeeID
        ORDER BY period_start DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE UpdatePersonalDetails
    @EmployeeID INT,
    @Phone VARCHAR(20),
    @Address VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF LEN(@Phone) < 5
        BEGIN
            RAISERROR('Invalid phone number', 16, 1);
            RETURN;
        END
         
        IF LEN(@Address) = 0
        BEGIN
            RAISERROR('Address cannot be empty', 16, 1);
            RETURN;
        END
        
        UPDATE Employee 
        SET phone = @Phone, 
            address = @Address
        WHERE employee_id = @EmployeeID;
        
        PRINT 'Personal details updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewMyMissions
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            mission_id,
            destination,
            start_date,
            end_date,
            status,
            manager_id
        FROM Mission
        WHERE employee_id = @EmployeeID
        ORDER BY start_date DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewEmployeeProfile
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            e.employee_id,
            e.full_name,
            e.national_id,
            e.date_of_birth,
            e.country_of_birth,
            e.phone,
            e.email,
            e.address,
            e.emergency_contact_name,
            e.emergency_contact_phone,
            e.relationship,
            e.employment_progress,
            e.employment_status,
            e.hire_date,
            p.position_title,
            d.department_name,
            m.full_name AS manager_name,
            st.type AS salary_type,
            pg.grade_name AS pay_grade
        FROM Employee e
        LEFT JOIN Position p ON e.position_id = p.position_id
        LEFT JOIN Department d ON e.department_id = d.department_id
        LEFT JOIN Employee m ON e.manager_id = m.employee_id
        LEFT JOIN SalaryType st ON e.salary_type_id = st.salary_type_id
        LEFT JOIN PayGrade pg ON e.pay_grade = pg.pay_grade_id
        WHERE e.employee_id = @EmployeeID;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE UpdateContactInformation
    @EmployeeID INT,
    @RequestType VARCHAR(50),
    @NewValue VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF @RequestType NOT IN ('Phone', 'Address', 'Email')
        BEGIN
            RAISERROR('Invalid request type. Must be Phone, Address, or Email', 16, 1);
            RETURN;
        END 
        IF LEN(@NewValue) = 0
        BEGIN
            RAISERROR('New value cannot be empty', 16, 1);
            RETURN;
        END
        
        IF @RequestType = 'Phone'
        BEGIN
            UPDATE Employee SET phone = @NewValue WHERE employee_id = @EmployeeID;
        END
        ELSE IF @RequestType = 'Address'
        BEGIN
            UPDATE Employee SET address = @NewValue WHERE employee_id = @EmployeeID;
        END
        ELSE IF @RequestType = 'Email'
        BEGIN 
            IF @NewValue NOT LIKE '%@%.%'
            BEGIN
                RAISERROR('Invalid email format', 16, 1);
                RETURN;
            END
            UPDATE Employee SET email = @NewValue WHERE employee_id = @EmployeeID;
        END
        
        PRINT 'Contact information updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewEmploymentTimeline
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
         
        SELECT 
            'Hire' AS event_type,
            hire_date AS event_date,
            'Hired as ' + p.position_title AS event_description
        FROM Employee e
        LEFT JOIN Position p ON e.position_id = p.position_id
        WHERE e.employee_id = @EmployeeID
        
        UNION ALL
        
        SELECT 
            'Department Transfer' AS event_type,
            GETDATE() AS event_date, 
            'Transferred to ' + d.department_name AS event_description
        FROM Employee e
        LEFT JOIN Department d ON e.department_id = d.department_id
        WHERE e.employee_id = @EmployeeID
        
        ORDER BY event_date DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE UpdateEmergencyContact
    @EmployeeID INT,
    @ContactName VARCHAR(100),
    @Relation VARCHAR(50),
    @Phone VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
         
        IF LEN(@ContactName) = 0
        BEGIN
            RAISERROR('Contact name cannot be empty', 16, 1);
            RETURN;
        END
         
        IF LEN(@Relation) = 0
        BEGIN
            RAISERROR('Relation cannot be empty', 16, 1);
            RETURN;
        END 
        IF LEN(@Phone) < 5
        BEGIN
            RAISERROR('Invalid phone number', 16, 1);
            RETURN;
        END
        
        UPDATE Employee 
        SET emergency_contact_name = @ContactName,
            relationship = @Relation,
            emergency_contact_phone = @Phone
        WHERE employee_id = @EmployeeID;
        
        PRINT 'Emergency contact updated successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE RequestHRDocument
    @EmployeeID INT,
    @DocumentType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
         
        IF LEN(@DocumentType) = 0
        BEGIN
            RAISERROR('Document type cannot be empty', 16, 1);
            RETURN;
        END
         
        IF @DocumentType NOT IN ('Employment Verification', 'Salary Certificate', 'Experience Letter', 'NOC')
        BEGIN
            RAISERROR('Invalid document type', 16, 1);
            RETURN;
        END 
        PRINT 'HR document request submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE NotifyProfileUpdate
    @EmployeeID INT,
    @notificationType VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END 
        DECLARE @MessageContent VARCHAR(255) = 'Profile update: ' + @notificationType;
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, urgency, notification_type)
        VALUES (@MessageContent, 'Low', 'Profile Update');
        
        SET @NotificationID = SCOPE_IDENTITY();
        
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        VALUES (@EmployeeID, @NotificationID, 'Pending');
        
        PRINT 'Profile update notification sent';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE LogFlexibleAttendance
    @EmployeeID INT,
    @Date DATE,
    @CheckIn TIME,
    @CheckOut TIME
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF @CheckIn >= @CheckOut
        BEGIN
            RAISERROR('Check-in time must be before check-out time', 16, 1);
            RETURN;
        END 
        IF EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @Date)
        BEGIN
            RAISERROR('Attendance already recorded for this date', 16, 1);
            RETURN;
        END
        
        DECLARE @Duration INT = DATEDIFF(MINUTE, @CheckIn, @CheckOut);
        
        INSERT INTO Attendance (employee_id, entry_time, exit_time, duration, login_method, logout_method)
        VALUES (@EmployeeID, 
                CAST(@Date AS DATETIME) + CAST(@CheckIn AS DATETIME), 
                CAST(@Date AS DATETIME) + CAST(@CheckOut AS DATETIME), 
                @Duration, 'Flexible', 'Flexible');
        
        SELECT @Duration AS TotalWorkingMinutes;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE NotifyMissedPunch
    @EmployeeID INT,
    @Date DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
 
        DECLARE @MissedType VARCHAR(20) = 'Unknown';
        
        IF EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @Date AND exit_time IS NULL)
        BEGIN
            SET @MissedType = 'Clock-Out';
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM Attendance WHERE employee_id = @EmployeeID AND CAST(entry_time AS DATE) = @Date)
        BEGIN
            SET @MissedType = 'Both';
        END
        
        DECLARE @MessageContent VARCHAR(255) = 'Missed ' + @MissedType + ' punch on ' + CONVERT(VARCHAR, @Date);
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, urgency, notification_type)
        VALUES (@MessageContent, 'Medium', 'Missed Punch');
        
        SET @NotificationID = SCOPE_IDENTITY();
        
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        VALUES (@EmployeeID, @NotificationID, 'Pending');
        
        SELECT @NotificationID AS NotificationID, @MessageContent AS Message;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE RecordMultiplePunches
    @EmployeeID INT,
    @ClockInOutTime DATETIME,
    @Type VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF @Type NOT IN ('In', 'Out')
        BEGIN
            RAISERROR('Type must be In or Out', 16, 1);
            RETURN;
        END
         
        IF @ClockInOutTime > GETDATE()
        BEGIN
            RAISERROR('Punch time cannot be in the future', 16, 1);
            RETURN;
        END
 
        PRINT 'Multiple punch recorded successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE SubmitCorrectionRequest
    @EmployeeID INT,
    @Date DATE,
    @CorrectionType VARCHAR(50),
    @Reason VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END 
        IF @CorrectionType NOT IN ('Missing Punch', 'Wrong Time', 'Wrong Date', 'Other')
        BEGIN
            RAISERROR('Invalid correction type', 16, 1);
            RETURN;
        END
         
        IF LEN(@Reason) = 0
        BEGIN
            RAISERROR('Reason cannot be empty', 16, 1);
            RETURN;
        END
         
        IF @Date > CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Cannot submit correction for future date', 16, 1);
            RETURN;
        END
         
        PRINT 'Correction request submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewRequestStatus
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END 
        SELECT 
            'Leave' AS request_type,
            request_id AS request_id,
            status,
            approval_timing AS decision_date
        FROM LeaveRequest
        WHERE employee_id = @EmployeeID
        
        UNION ALL
        
        SELECT 
            'Reimbursement' AS request_type,
            reimbursement_id AS request_id,
            current_status AS status,
            approval_date AS decision_date
        FROM Reimbursement
        WHERE employee_id = @EmployeeID
        
        ORDER BY decision_date DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE AttachLeaveDocuments
    @LeaveRequestID INT,
    @FilePath VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END 
        IF LEN(@FilePath) = 0
        BEGIN
            RAISERROR('File path cannot be empty', 16, 1);
            RETURN;
        END
        
        INSERT INTO LeaveDocument (leave_request_id, file_path)
        VALUES (@LeaveRequestID, @FilePath);
        
        PRINT 'Leave document attached successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ModifyLeaveRequest
    @LeaveRequestID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END
         
        DECLARE @CurrentStatus VARCHAR(50);
        SELECT @CurrentStatus = status FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        
        IF @CurrentStatus NOT IN ('Pending', 'Returned')
        BEGIN
            RAISERROR('Cannot modify approved or rejected leave request', 16, 1);
            RETURN;
        END
         
        IF @StartDate > @EndDate
        BEGIN
            RAISERROR('Start date must be before end date', 16, 1);
            RETURN;
        END
        
        DECLARE @Duration INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
        
        UPDATE LeaveRequest 
        SET justification = @Reason,
            duration = @Duration
        WHERE request_id = @LeaveRequestID;
        
        PRINT 'Leave request modified successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE CancelLeaveRequest
    @LeaveRequestID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @LeaveRequestID)
        BEGIN
            RAISERROR('Leave request not found', 16, 1);
            RETURN;
        END
         
        DECLARE @CurrentStatus VARCHAR(50);
        SELECT @CurrentStatus = status FROM LeaveRequest WHERE request_id = @LeaveRequestID;
        
        IF @CurrentStatus NOT IN ('Pending', 'Returned')
        BEGIN
            RAISERROR('Cannot cancel approved or rejected leave request', 16, 1);
            RETURN;
        END
        
        UPDATE LeaveRequest 
        SET status = 'Cancelled'
        WHERE request_id = @LeaveRequestID;
        
        PRINT 'Leave request cancelled successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO 
CREATE PROCEDURE ViewLeaveBalance
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            l.leave_type,
            le.entitlement AS TotalDays,
            ISNULL(SUM(CASE WHEN lr.status = 'Approved' THEN lr.duration ELSE 0 END), 0) AS UsedDays,
            (le.entitlement - ISNULL(SUM(CASE WHEN lr.status = 'Approved' THEN lr.duration ELSE 0 END), 0)) AS RemainingDays
        FROM LeaveEntitlement le
        INNER JOIN [Leave] l ON le.leave_type_id = l.leave_id
        LEFT JOIN LeaveRequest lr ON le.employee_id = lr.employee_id AND le.leave_type_id = lr.leave_id
        WHERE le.employee_id = @EmployeeID
        GROUP BY l.leave_type, le.entitlement;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE ViewLeaveHistory
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END
        
        SELECT 
            lr.request_id,
            l.leave_type,
            lr.justification,
            lr.duration,
            lr.status,
            lr.approval_timing
        FROM LeaveRequest lr
        INNER JOIN [Leave] l ON lr.leave_id = l.leave_id
        WHERE lr.employee_id = @EmployeeID
        ORDER BY lr.approval_timing DESC;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE PROCEDURE SubmitLeaveAfterAbsence
    @EmployeeID INT,
    @LeaveTypeID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Reason VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID AND is_active = 1)
        BEGIN
            RAISERROR('Employee not found or inactive', 16, 1);
            RETURN;
        END
  
        IF NOT EXISTS (SELECT 1 FROM [Leave] WHERE leave_id = @LeaveTypeID)
        BEGIN
            RAISERROR('Leave type not found', 16, 1);
            RETURN;
        END
  
        IF @EndDate >= CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('Leave after absence must be for past dates', 16, 1);
            RETURN;
        END
        
        DECLARE @Duration INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;
        
        INSERT INTO LeaveRequest (employee_id, leave_id, justification, duration, status)
        VALUES (@EmployeeID, @LeaveTypeID, @Reason, @Duration, 'Pending');
        
        PRINT 'Leave after absence submitted successfully';
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
 
CREATE PROCEDURE NotifyLeaveStatusChange
    @EmployeeID INT,
    @RequestID INT,
    @Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY 
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Employee not found', 16, 1);
            RETURN;
        END 
        IF NOT EXISTS (SELECT 1 FROM LeaveRequest WHERE request_id = @RequestID AND employee_id = @EmployeeID)
        BEGIN
            RAISERROR('Leave request not found for this employee', 16, 1);
            RETURN;
        END
         
        IF @Status NOT IN ('Approved', 'Rejected', 'Returned', 'Modified')
        BEGIN
            RAISERROR('Invalid status', 16, 1);
            RETURN;
        END
        
        DECLARE @MessageContent VARCHAR(255) = 'Leave request ' + @RequestID + ' has been ' + @Status;
        DECLARE @NotificationID INT;
        
        INSERT INTO Notification (message_content, urgency, notification_type)
        VALUES (@MessageContent, 'Medium', 'Leave Status');
        
        SET @NotificationID = SCOPE_IDENTITY();
        
        INSERT INTO Employee_Notification (employee_id, notification_id, delivery_status)
        VALUES (@EmployeeID, @NotificationID, 'Pending');
        
        SELECT @NotificationID AS NotificationID, @MessageContent AS Message;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT 'All Employee procedures created successfully';
