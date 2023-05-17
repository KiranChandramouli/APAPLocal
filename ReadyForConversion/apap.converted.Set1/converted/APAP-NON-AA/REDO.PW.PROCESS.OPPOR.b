SUBROUTINE  REDO.PW.PROCESS.OPPOR(R.DATA,L.PROCESS.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the Process Id

* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who           Reference            Description
* 13-SEP-2011     SHANKAR RAJU     ODR-2011-07-0162      Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_PW.COMMON
    $INSERT I_F.PW.PROCESS

    GOSUB PROCESS

RETURN

PROCESS:
*-------
    PROCESS.TXN.ID = PW$ACTIVITY.TXN.ID
    CALL PW.FIND.PROCESS(PROCESS.TXN.ID,PW.PROCESS.ID)        ;* get the PW.PROCESS name
    L.PROCESS.ID = PW.PROCESS.ID

RETURN
END
