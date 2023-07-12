*-----------------------------------------------------------------------------
* <Rating>90</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.CREDIT.CARD.UPD.SELECT

* One time routine update the REDO.APAP.CREDIT.CARD.DET table
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT LAPAP.BP I_F.REDO.APAP.CREDIT.CARD.DET
    $INSERT LAPAP.BP I_REDO.APAP.CREDIT.CARD.UPD.COMMON


    GOSUB PROCESS
    RETURN


PROCESS:
********
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT ":FN.SAVELST
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)

    READ R.SAVELST FROM F.SAVELST,SEL.REC ELSE RETURN
    CALL BATCH.BUILD.LIST('',R.SAVELST)
    RETURN
END
