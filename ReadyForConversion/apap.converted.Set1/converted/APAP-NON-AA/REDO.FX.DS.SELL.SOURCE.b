SUBROUTINE REDO.FX.DS.SELL.SOURCE(IN.OUT.PARA)
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
*15-FEB-2012       Prabhu N          PACS00249258                modified to eb lookup
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.USER
    $INSERT I_F.REDO.BUY.SELL.SOURCE

    GOSUB PROCESS

RETURN


********
PROCESS:
********
* Getthe description for source

    Y.LOOKUP.ID   = "L.TT.FX.SEL.DST"
    Y.LOOOKUP.VAL = IN.OUT.PARA
    Y.DESC.VAL    = ''
    CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
    IN.OUT.PARA= Y.DESC.VAL

RETURN

END
