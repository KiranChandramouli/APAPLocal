*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.APAP.CREDIT.CARD.UPD.LOAD

* One time routine update the REDO.APAP.CREDIT.CARD.DET table
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT LAPAP.BP I_F.REDO.APAP.CREDIT.CARD.DET
    $INSERT LAPAP.BP I_REDO.APAP.CREDIT.CARD.UPD.COMMON


    GOSUB INIT
    RETURN

INIT:
*****
    FN.REDO.APAP.CREDIT.CARD.DET = 'F.REDO.APAP.CREDIT.CARD.DET'; F.REDO.APAP.CREDIT.CARD.DET = ''
    CALL OPF(FN.REDO.APAP.CREDIT.CARD.DET,F.REDO.APAP.CREDIT.CARD.DET)
    FN.SAVELST = '../bnk.run/CC.LOGO'; F.SAVELST = ''
    OPEN FN.SAVELST TO F.SAVELST ELSE
        CREATE F.SAVELST ELSE
            RETURN
        END
    END
    R.SAVELST = ''
    RETURN

END
