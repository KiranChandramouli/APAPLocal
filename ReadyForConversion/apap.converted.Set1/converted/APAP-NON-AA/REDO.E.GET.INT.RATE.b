SUBROUTINE REDO.E.GET.INT.RATE
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is attached as conversion routine to INT.RATE field of enquiry REDO.AC.PROFIT.LOSS
* for getting the interest rate from ACI or GCI record
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 28-JUN-2010  N.Satheesh Kumar   ODR-2009-10-0325       Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_ENQUIRY.COMMON


    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*----------
INITIALISE:
*----------
*------------------------------------------------------------------
* This section initialises necessary variables used in this routine
*------------------------------------------------------------------

    ACC.CUR = R.RECORD<AC.CURRENCY>
    ACC.CATEG = R.RECORD<AC.CATEGORY>
    ACC.COND = R.RECORD<AC.CONDITION.GROUP>
    ACC.BAL = R.RECORD<AC.WORKING.BALANCE>

    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT = ''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
    F.GROUP.CREDIT.INT = ''
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)


RETURN

*-------
PROCESS:
*-------
*-------------------------------------------------------------
* This section gets the interest rate and assigns it to O.DATA
*-------------------------------------------------------------

    FILE.NAME = FN.ACCOUNT.CREDIT.INT
    SEL.ACI = 'SSELECT ':FN.ACCOUNT.CREDIT.INT:' WITH @ID LIKE ':O.DATA:'...'
    CALL EB.READLIST(SEL.ACI,SEL.LIST.ACI,'',SEL.NORACI,SEL.RET)
    IF SEL.LIST.ACI NE '' THEN
        INT.KEY=SEL.LIST.ACI<SEL.NORACI>
    END
    IF INT.KEY EQ '' THEN
        FILE.NAME = FN.GROUP.CREDIT.INT
        FIND.ID = ACC.COND:ACC.CUR

        SEL.GCI = 'SSELECT ':FN.GROUP.CREDIT.INT:' WITH @ID LIKE ':FIND.ID:'...'
        CALL EB.READLIST(SEL.GCI,SEL.LIST.GCI,'',SEL.NOR.GCI,SEL.RET)
        IF SEL.LIST.GCI NE '' THEN
            INT.KEY=SEL.LIST.GCI<SEL.NOR.GCI>
        END
    END
    IF FILE.NAME EQ FN.GROUP.CREDIT.INT  THEN
        GOSUB PROCESS.GCI
    END ELSE
        GOSUB PROCESS.ACI
    END
RETURN
*-----------
PROCESS.GCI:
*-----------
*--------------------------------------------------------------------
* This section gets the required details from GROUP.CREDIT.INT record
*--------------------------------------------------------------------

    R.GROUP.CREDIT.INT = ''
    CALL CACHE.READ(FN.GROUP.CREDIT.INT, INT.KEY, R.GROUP.CREDIT.INT, CGI.ERR)
    CI.LIM.AMT = R.GROUP.CREDIT.INT<IC.GCI.CR.LIMIT.AMT>
    INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE>
    BASIC.RATE.KEY = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE>
    GOSUB GET.INT.RATE
RETURN

*-----------
PROCESS.ACI:
*-----------
*----------------------------------------------------------------------
* This section gets the required details from ACCOUNT.CREDIT.INT record
*----------------------------------------------------------------------

    R.ACCOUNT.CREDIT.INT = ''
    CALL F.READ(FN.ACCOUNT.CREDIT.INT,INT.KEY,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,CGI.ERR)
    CI.LIM.AMT = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.LIMIT.AMT>
    INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE>
    BASIC.RATE.KEY = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.BASIC.RATE>
    GOSUB GET.INT.RATE
RETURN

*------------
GET.INT.RATE:
*------------
*-----------------------------------------------------------------------------------------------------
* This section gets the interest rate based on the amount and assigns it to the common variable O.DATA
*-----------------------------------------------------------------------------------------------------

    INT.RATE.CNT = DCOUNT(INT.RATE,@VM)
    IF INT.RATE.CNT EQ 1 THEN
        O.DATA = INT.RATE
        RETURN
    END
    BASIC.RATE.CNT = DCOUNT(BASIC.RATE.KEY,@VM)
    IF BASIC.RATE.CNT EQ 1 THEN
        BASIC.RATE.KEY := ACC.CUR:TODAY
        BASIC.RATE = ''
        CALL EB.GET.INTEREST.RATE(BASIC.RATE.KEY,BASIC.RATE)
        O.DATA = BASIC.RATE
        RETURN
    END
    LIM.AMT.CNT = 0
    LOOP
        LIM.AMT.CNT += 1
        REMOVE LIM.AMT FROM CI.LIM.AMT SETTING LIM.AMT.POS
    WHILE LIM.AMT:LIM.AMT.POS
        IF ACC.BAL LE LIM.AMT THEN
            BREAK
        END
    REPEAT
    IF INT.RATE<1,LIM.AMT.CNT> EQ '' THEN
        IBASIC.RATE.KEY = BASIC.RATE.KEY<1,LIM.AMT.CNT>
        IBASIC.RATE.KEY := ACC.CUR:TODAY
        BASIC.RATE = ''
        CALL EB.GET.INTEREST.RATE(IBASIC.RATE.KEY,BASIC.RATE)
        O.DATA =BASIC.RATE
    END ELSE
        O.DATA = INT.RATE<1,LIM.AMT.CNT>
    END
RETURN
END
