SUBROUTINE REDO.DS.ST.COMMENTS(IN.OUT.PARA)
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
* PROGRAM NAME : REDO.DS.ST.COMMENTS
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 14-May-2011      Pradeep S          PACS00062654                Initail Creation
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    CHANGE @VM TO @FM IN IN.OUT.PARA

    CHANGE @SM TO @FM IN IN.OUT.PARA


RETURN
END
