*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.AZ.REINV.REVERSE.SELECT
*
* Description: This is routine to remove the inactive / closed deposit reinvested account.
*
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.ACCOUNT
    $INCLUDE T24.BP I_F.AZ.ACCOUNT
    $INCLUDE T24.BP I_F.ACCOUNT.CLOSURE
    $INCLUDE T24.BP I_F.AZ.PRODUCT.PARAMETER
    $INCLUDE LAPAP.BP I_REDO.AZ.REINV.REVERSE.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*****
    SEL.ACCT = ''; SEL.REC = ''; SEL.LIST = ''; SEL.ERR = ''; Y.AZ.CATEGORY = ''
    RETURN

PROCESS:
********
    SEL.ACCT = "SELECT ":FN.ACCOUNT:" WITH ((CATEGORY GE '6013' AND CATEGORY LE '6020') OR (CATEGORY GE '6600' AND CATEGORY LE '6699')) AND (ONLINE.ACTUAL.BAL EQ 0 OR ONLINE.ACTUAL.BAL EQ '')"
    CALL EB.READLIST(SEL.ACCT,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST("",SEL.REC)
    RETURN
END
