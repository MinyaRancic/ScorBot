// RobotDll.h : main header file for the RobotDll DLL
//

extern "C" __declspec(dllexport) int RInitialize(void);
//Initializes Intelitek USBC.dll - Must be called first after loading this Dll

extern "C" __declspec(dllexport) int RIsInitDone(void);
//Returns a "1" when the above initialization is actually done, not when Initialization returns

extern "C" __declspec(dllexport) int RGripOpen(void);
//Wide open gripper

extern "C" __declspec(dllexport) int RGripClose(void);
//fully closed gripper

extern "C" __declspec(dllexport) int RDigOn(int);
//Turns a binary digit "on" - parameter must be 1-8.  Routine makes adjustment for true 0-7 range

extern "C" __declspec(dllexport) int RDigOff(int);
//Turns a binary digit "off" - parameter must be 1-8, matching output display

extern "C" __declspec(dllexport) int RHome(char);
//Homing routine for Robot - should be called at beginning of session - returns a 1 if successful
//char parameter should be a 'A' character to home all robot axes
//Note: May not return at all if not successful

extern "C" __declspec(dllexport) int RIsHomeDone(void);
//returns a 1 if homing is complete

extern "C" __declspec(dllexport) int RGetXYZPR(float*,float*,float*,float*,float*);
//gets current position in XYZ Pitch and Roll format.  XYZ in micrometers, P,R in 1/1000 degree
//values are returned in float pointers.  Function returns a 1 if successful

extern "C" __declspec(dllexport) int RGetBSEPR(float*,float*,float*,float*,float*);
//gets current position in relative joint angles base, shoulder, elbow, pitch roll in 1/1000 degree
//parameters are returned in float pointers.  Function returns a 1 if successful

extern "C" __declspec(dllexport) int RControl(char,int);
//turn on or off axes control.  char parameter is 'A' for all robot axes.  1 turns on 0 turns off
//function returns a 1 if successful

extern "C" __declspec(dllexport) int RDefineVector(char*,int);
//define a vector to receive points.  char* parameter is a name of 16 or less characters
//int parameter is max number of points to receive - up to 10000 allowed
//in .m files 'USNA',1000 is used

extern "C" __declspec(dllexport) int RAddToVecXYZPR(char*,int,int,long,long,long,long,long);
//Adds a point to a vector in XYZPR format.  char* parameter is name of vector, first int is
//point number, second int is 0 for absolute point, 1 for relative point.  Final longs are XYZPR
//where XYZ are in micrometers and P,R are in 1/1000 degree. In spite of documentation, you cannot 
//add positions in joint format with this routine.  Returns 0 is point is outside of workspace,
//returns point value if successful

extern "C" __declspec(dllexport) int RMoveLinear(char*,int);
//Uses linear routine to move to a point in a vector. char * is vector name, int is point
//returns a 1 if successful

extern "C" __declspec(dllexport) int RMoveJoint(char*,int);
//uses joint routine to move to a point in a vector.  char * is vector name, int is point
//returns a 1 if successful

extern "C" __declspec(dllexport) int RIsMotionDone(void);
//use to determine when motion is actually done.  Use when multiple points are being passed to robot
//in quick succession.  returns a 1 when motion is complete and a new command can be accepted

extern "C" __declspec(dllexport) int RGripMetric(int);
//moves gripper to a specified position.  Int parameter is grip opening in mm
//returns a 1 if successful

extern "C" __declspec(dllexport) int RGetMaxPoint(int);
//returns the highest point number stored in the USNA array, 0 if no points stored.

extern "C" __declspec(dllexport) int RGetJaw(void);
//returns grip opening in mm 

extern "C" __declspec(dllexport) int RSetTime(int);
//Sets time to take between move points.  Time parameter is in msec

extern "C" __declspec(dllexport) int RSetSpeed(int);
//sets speed to take between points.  Speed parameter is in percent of maximum (50=50% of max)

extern "C" __declspec(dllexport) int RIsTeach(void);
//returns a 1 if teach pendant is in "teach" mode.  Useful to avoid confusion in some routines

extern "C" __declspec(dllexport) int RIsError(void);
//returns 0 if no error, returns error number if an error occurred

