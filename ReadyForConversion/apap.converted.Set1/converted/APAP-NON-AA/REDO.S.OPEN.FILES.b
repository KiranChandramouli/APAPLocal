SUBROUTINE REDO.S.OPEN.FILES
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an internal call routine called by the batch routine REDO.B.LY.POINT.GEN to
* open the necessary files used in the batch routine
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : REDO.B.LY.POINT.GEN
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
* 01-JUN-2012      RMONDRAGON     ODR-2011-06-0243      Update for Utilization Functionality.
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LY.POINT.GEN.COMMON

    GOSUB OPEN.T24.FILES
    GOSUB OPEN.TEMP.FILE
RETURN

*--------------
OPEN.T24.FILES:
*--------------
*-------------------------------------------
* This section opens the necessary T24 files
*-------------------------------------------

    FN.REDO.LY.MODALITY = 'F.REDO.LY.MODALITY'
    F.REDO.LY.MODALITY = ''
    CALL OPF(FN.REDO.LY.MODALITY,F.REDO.LY.MODALITY)

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.POINTS.US = 'F.REDO.LY.POINTS.US'
    F.REDO.LY.POINTS.US = ''
    CALL OPF(FN.REDO.LY.POINTS.US,F.REDO.LY.POINTS.US)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.BALANCE.MOVEMENT = 'F.BALANCE.MOVEMENT'
    F.BALANCE.MOVEMENT = ''
    CALL OPF(FN.BALANCE.MOVEMENT,F.BALANCE.MOVEMENT)

    FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY = ''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.STMT.ACCT.CR = 'F.STMT.ACCT.CR'
    F.STMT.ACCT.CR = ''
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)

    FN.REDO.LY.MASTERPRGDR = 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

RETURN

*--------------
OPEN.TEMP.FILE:
*--------------
*----------------------------------------------
* This section opens the necessary UD type file
*----------------------------------------------

    FN.TEMP.LY.POINT.GEN = 'F.TEMP.LY.POINT.GEN'
    F.TEMP.LY.POINT.GEN = ''
*OPEN Converted by TUS-Convert
*  OPEN FN.TEMP.LY.POINT.GEN TO F.TEMP.LY.POINT.GEN THEN NULL ;*Tus Start
    CALL OPF(FN.TEMP.LY.POINT.GEN,F.TEMP.LY.POINT.GEN) ;*Tus End

RETURN

END
