*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.CP.OVERPAY.SELECT

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
* Dev by: V.P.Ashokkumar
* Date  : 10/10/2016
*-------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE T24.BP I_BATCH.FILES
    $INCLUDE LAPAP.BP I_F.REDO.AA.CP.OVERPAYMENT
    $INCLUDE TAM.BP I_F.REDO.AA.OVERPAYMENT
    $INCLUDE LAPAP.BP I_REDO.B.AA.OVERPAY.COMMON


    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END
    GOSUB PROCESS
    RETURN

BUILD.CONTROL.LIST:
*******************
    CONTROL.LIST<-1> = "NEW.OVERPAY"
    CONTROL.LIST<-1> = "OLD.OVERPAY"
    RETURN

PROCESS:
********
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
    BEGIN CASE
    CASE CONTROL.LIST<1,1> EQ 'NEW.OVERPAY'
        SEL.CMD = "SELECT ":FN.REDO.AA.CP.OVERPAYMENT:" WITH STATUS EQ 'PENDIENTE' AND (NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY:")"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    CASE CONTROL.LIST<1,1> EQ 'OLD.OVERPAY'
        SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ 'APLICADO' AND NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    END CASE
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN
END
