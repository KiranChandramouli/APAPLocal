SUBROUTINE REDO.DS.INVESTMENT.TERM(IN.OUT.PARA)
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
* PROGRAM NAME : REDO.DS.INVESTMENT.TERM
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 16-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
* 28-Mar-2011      Pradeep S         PACS00051213                Need to consider calender days
* 18-Jul-2011      Pradeep S         PACS00090196                CDD command changed
* 05-Feb-2013      Pradeep S         PACS00247754                Mapping details changed. Base defaulted to 365.
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
* Initialising necessay variables
*
*
    FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.SECURITY.MASTER = ""
    R.SECURITY.MASTER = ""
    E.SECURITY.MASTER = ""
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
RETURN
********
PROCESS:
********
* Process to find Y.SECURITY.TERM.VAL
*
    Y.ID = IN.OUT.PARA
    Y.SECURITY.CODE = R.NEW(SC.SBS.SECURITY.CODE)
    CALL F.READ(FN.SECURITY.MASTER,Y.SECURITY.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
    Y.INTEREST.DAY = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    Y.BASE.VALUE = FIELD(Y.INTEREST.DAY,'/',2,1)
*
    Y.MATURITY.DATE = R.NEW(SC.SBS.MATURITY.DATE)
    Y.VALUE.DATE = R.NEW(SC.SBS.VALUE.DATE)
    IN.OUT.PARA = ''
    Y.REGION = ""
    Y.DIFF.DAYS = "C" ;*PACS00051213 - S/E
*PACS00090196 - S
    IF Y.VALUE.DATE NE '' AND Y.MATURITY.DATE NE '' THEN
        CALL CDD(Y.REGION,Y.VALUE.DATE,Y.MATURITY.DATE,Y.DIFF.DAYS)
        Y.DIFF.DAYS = ABS(Y.DIFF.DAYS)
        Y.SECURITY.TERM.VAL = Y.DIFF.DAYS/365         ;* PACS00247754 - S/E
        Y.SECURITY.TERM.VAL = DROUND(Y.SECURITY.TERM.VAL,"2")
        IN.OUT.PARA = FMT(Y.SECURITY.TERM.VAL,"L2#10")
    END
*PACS00090196 - E
*

RETURN
END
