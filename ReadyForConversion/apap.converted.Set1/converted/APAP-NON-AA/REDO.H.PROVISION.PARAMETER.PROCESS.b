SUBROUTINE REDO.H.PROVISION.PARAMETER.PROCESS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.PROVISION.PARAMETER.PROCESS is a validation routine attached to the TEMPLATE
*                    - REDO.H.PROVISION.PARAMETER, the routine checks if the value entered in the
*                    COB.FREQUENCY is a valid frequency or not
*Linked With       : Template - REDO.H.PROVISION.PARAMETER
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.PROVISION.PARAMETER           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
* 22-Oct-2010        G.Bharath          ODR-2009-11-0159 B.23A        New Validations added
* 14-APR-2011        RIYAS              ODR-2010-09-0167 B.23B        NEW VALIDATION ADDED
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    GOSUB CHECK.DAYS
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DAYS:
**********
    Y.MIN.DAYS = R.NEW(PROV.MIN.DAYS)
    Y.MAX.DAYS = R.NEW(PROV.MAX.DAYS)
    Y.PERCENTAGE = R.NEW(PROV.PERCENTAGE)
    Y.COUNT.VM.MAX = DCOUNT(Y.MIN.DAYS,@VM)
    Y.CNT.VM = 1
    LOOP
    WHILE Y.CNT.VM LE Y.COUNT.VM.MAX
        Y.SM.MAX = Y.MAX.DAYS<1,Y.CNT.VM>
        Y.SM.MIN = Y.MIN.DAYS<1,Y.CNT.VM>
        Y.SM.PER= Y.PERCENTAGE<1,Y.CNT.VM>
        GOSUB SM.DAY.CAL
        Y.CNT.VM += 1
    REPEAT
RETURN
**********
SM.DAY.CAL:
**********

    Y.COUNT.SM.MAX = DCOUNT(Y.SM.MAX,@SM)
    Y.COUNT.SM.MIN = DCOUNT(Y.SM.MIN,@SM)
    Y.COUNT.SM.PER=DCOUNT(Y.SM.PER,@SM)
    Y.CNT.SM = 1
    LOOP
    WHILE Y.CNT.SM LE Y.COUNT.SM.MAX-1
        Y.CNT.SM1 = Y.CNT.SM + 1
        Y.MAX.DAYS1 = Y.MAX.DAYS<1,Y.CNT.VM,Y.CNT.SM>
        Y.MIN.DAYS1 = Y.MIN.DAYS<1,Y.CNT.VM,Y.CNT.SM>
        Y.PERCENTAGE1=Y.PERCENTAGE<1,Y.CNT.VM,Y.CNT.SM>

        GOSUB DAYS.CHECK

        Y.MIN.NEXT = Y.MIN.DAYS<1,Y.CNT.VM,Y.CNT.SM1>
        Y.MAX.NEXT = Y.MAX.DAYS<1,Y.CNT.VM,Y.CNT.SM1>
        Y.PERCENTAGE.NEXT=Y.PERCENTAGE<1,Y.CNT.VM,Y.CNT.SM1>
*GOSUB PERC.GT.CHECK
        GOSUB PERC.SAME.CHECK

        IF Y.MIN.NEXT LE Y.MAX.DAYS1 THEN
            AF = PROV.MIN.DAYS
            AV = Y.CNT.VM
            AS = Y.CNT.SM1
            ETEXT = "EB-RANGE.DEFINED"
            CALL STORE.END.ERROR
        END
        Y.CNT.SM += 1
    REPEAT

RETURN

*-----------
DAYS.CHECK:
***********
    IF Y.MIN.DAYS1 GE Y.MAX.DAYS1 THEN
        AF = PROV.MAX.DAYS
        AV = Y.CNT.VM
        AS = Y.CNT.SM
        ETEXT = "EB-MIN.DAYS"

        CALL STORE.END.ERROR
    END

RETURN
**************
*PERC.GT.CHECK:
***************
*   IF Y.PERCENTAGE.NEXT LT Y.PERCENTAGE1 THEN
*      AF = PROV.PERCENTAGE
*     AV = Y.CNT.VM
*    AS = Y.CNT.SM1
*   ETEXT = "EB-PERC.GT.CHECK"
*  CALL STORE.END.ERROR
*    END
*   RETURN
**************
PERC.SAME.CHECK:
***************
    IF Y.PERCENTAGE.NEXT EQ Y.PERCENTAGE1 THEN
        AF = PROV.PERCENTAGE
        AV = Y.CNT.VM
        AS = Y.CNT.SM1
        ETEXT = "EB-PERC.SAME.CHECK"
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------------------------------
END       ;* End of Program
