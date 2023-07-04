* @ValidationCode : MjoxMDQ0NDQ0ODY2OkNwMTI1MjoxNjgyNDEyMzU1ODM1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ACTIVATION.STATUS
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SWAMINATHAN
* PROGRAM NAME: REDO.V.VAL.ACTIVATION.STATUS
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to check card status activation
* LATAM.CARD.ORDER,REDO.ACTIVATION
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                WHO                         REFERENCE                DESCRIPTION
*9.03.2011        Swaminathan                ODR-2010-03-0400           INITIAL CREATION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    Y.OLD.STATUS = R.OLD(CARD.IS.CARD.STATUS)

    IF Y.OLD.STATUS EQ '35' OR Y.OLD.STATUS EQ '60' OR Y.OLD.STATUS EQ '52' OR  Y.OLD.STATUS EQ '92' OR  Y.OLD.STATUS EQ '93' OR Y.OLD.STATUS EQ '95' THEN
        ETEXT = "EB-CARD.STATUS.NT.ALLOW"
        CALL STORE.END.ERROR
    END
RETURN
END
