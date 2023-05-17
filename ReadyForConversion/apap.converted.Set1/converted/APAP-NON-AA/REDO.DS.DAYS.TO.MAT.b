SUBROUTINE REDO.DS.DAYS.TO.MAT(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.DS.DAYS.TO.MAT
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 11-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
* 28-Mar-2011      Pradeep S         PACS00051213                Mapping was changed
* 18-JuL-2011      Pradeep S         PACS00090196                CDD command changed
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER

*PACS00051213 - S
* GOSUB PROCESS
    GOSUB NEW.PROCESS
*PACS00051213 - E

RETURN

********
PROCESS:
********
* Process to find y.diff.days
*
    Y.ID = IN.OUT.PARA
    Y.MATURITY.DATE = R.NEW(SC.SBS.MATURITY.DATE)
    Y.ISSUE.DATE = R.NEW(SC.SBS.ISSUE.DATE)
    Y.REGION = ""
    Y.DIFF.DAYS = ""
    CALL CDD(Y.REGION,Y.ISSUE.DATE,Y.MATURITY.DATE,Y.DIFF.DAYS)
    IN.OUT.PARA = Y.DIFF.DAYS
RETURN

************
NEW.PROCESS:
************
* PACS00051213 - S

    SEC.CODE.ID = R.NEW(SC.SBS.SECURITY.CODE)

    FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.SECURITY.MASTER = ''

    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)


    CALL F.READ(FN.SECURITY.MASTER,SEC.CODE.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,SECURITY.MASTER.ERR)
    Y.SM.MAT.DATE = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>

    Y.SCT.VALUE.DATE = R.NEW(SC.SBS.VALUE.DATE)

    Y.REGION = ""
    Y.DIFF.DAYS = "C"
    IN.OUT.PARA = ''
*PACS00090196 - S
    IF Y.SM.MAT.DATE NE '' AND Y.SCT.VALUE.DATE NE '' THEN
        CALL CDD(Y.REGION,Y.SM.MAT.DATE,Y.SCT.VALUE.DATE,Y.DIFF.DAYS)
        IN.OUT.PARA = ABS(Y.DIFF.DAYS)
    END
*PACS00090196 - E
RETURN

* PACS00051213 - E


END
