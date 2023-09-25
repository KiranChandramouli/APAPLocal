* @ValidationCode : MjoxMDU2NTIwOTg1OkNwMTI1MjoxNjkwMTY3NTU2NDAwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE	        	AUTHOR	          Modification                 DESCRIPTION
*13/07/2023	     VIGNESHWARI 	  MANUAL R22 CODE CONVERSION	    LAPAP.BP is removed in insertfile
*13/07/2023	    CONVERSION TOOL   AUTO R22 CODE CONVERSION	        NOCHANGE
*-----------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.CREDIT.CARD.UPD.LOAD

* One time routine update the REDO.APAP.CREDIT.CARD.DET table
* Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CREDIT.CARD.DET
    $INSERT I_REDO.APAP.CREDIT.CARD.UPD.COMMON

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
