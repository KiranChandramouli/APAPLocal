SUBROUTINE REDO.DS.BUY.SELL.SOURCE(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.DS.BUY.SELL.SOURCE
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 29-APR-2011      Pradeep S         PACS00054288                 Initial Creation
* 27-Jun-2012      Pradeep S         PACS00204543                 Language specific chages
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BUY.SELL.SOURCE

    GOSUB INIT
    GOSUB PROCESS

RETURN

*****
INIT:
*****
* Initialisation of variables
*
    Y.ID = IN.OUT.PARA

    FN.REDO.BUY.SELL.SOURCE = 'F.REDO.BUY.SELL.SOURCE'
    F.REDO.BUY.SELL.SOURCE = ''

    CALL OPF(FN.REDO.BUY.SELL.SOURCE,F.REDO.BUY.SELL.SOURCE)

RETURN

********
PROCESS:
********
* Getthe description for source

    R.REC.SOURCE = ''
    CALL F.READ(FN.REDO.BUY.SELL.SOURCE,Y.ID,R.REC.SOURCE,F.REDO.BUY.SELL.SOURCE,ERR.SOURCE)
    IF R.REC.SOURCE THEN
        IN.OUT.PARA = R.REC.SOURCE<BS.SRC.DESCRIPTION,LNGG>
        IF NOT(IN.OUT.PARA) THEN
            IN.OUT.PARA = R.REC.SOURCE<BS.SRC.DESCRIPTION,1>
        END
    END

RETURN

END
