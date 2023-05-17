SUBROUTINE REDO.B.SC.REV.DISC.ENTRY.SELECT
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for Spec entries that raised on the bussiness day from RE.SPEC.ENT.TODAY to reverse and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.B.SC.REV.DISC.ENTRY.SELECT
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 06 Jul 2011      Pradeep S          PACS00080124        Initial creation
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_REDO.B.SC.REV.DISC.ENTRY.COMMON
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*SEL.CMD = 'SELECT ':FN.SPEC.TODAY:' WITH @ID LIKE SC...'
    SEL.CMD = 'SELECT ':FN.SC.TRADING.POSITION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)

RETURN
END
