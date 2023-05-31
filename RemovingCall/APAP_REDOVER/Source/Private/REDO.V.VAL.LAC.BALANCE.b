* @ValidationCode : MjotNzU5MTU4ODM2OkNwMTI1MjoxNjgyNDEyMzYyMzE0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:02
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
SUBROUTINE REDO.V.VAL.LAC.BALANCE
**********************************************************************
*  COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*  DEVELOPED BY: S DHAMU
*  PROGRAM NAME: REDO.CARD.CHN.VAL
*  ODR NO      : ODR-2010-08-0469
* ----------------------------------------------------------------------
*  DESCRIPTION: This routine is to fetch l.ac.av.bal.
*


*    IN PARAMETER: NA
*    OUT PARAMETER: NA
*    LINKED WITH: NA
*----------------------------------------------------------------------
*   Modification History :
*   -----------------------
*    DATE           WHO           REFERENCE         DESCRIPTION
*    22.11.2010   S DHAMU     ODR-2010-08-0469   INITIAL CREATION
*-------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                          = TO EQ
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.TELLER.COMMON
    $INSERT I_F.ACCOUNT


    IF V$FUNCTION EQ 'R' OR MESSAGE NE '' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS
RETURN


*****
INIT:
*****

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

********
PROCESS:
********

    APL.ARRAY = "ACCOUNT"
    APL.FIELD = 'L.AC.AV.BAL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.AC.AV.BAL.POS = FLD.POS<1,1>


    Y.ACCOUNT.NO = COMI
    IF Y.ACCOUNT.NO[1,3] MATCHES '3A' THEN
        RETURN
    END


    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,DEB.ERR)
    IF R.ACCOUNT EQ '' THEN
        ETEXT = 'EB-INVALD.DC.NUMBER'
        CALL STORE.END.ERROR
    END

    FIELD.NAME = FT.DEBIT.ACCT.NO
    R.SS = ''
    CALL FIELD.NAMES.TO.NUMBERS(FIELD.NAME,R.SS,FIELD.NO,'','','','','')

    IF APPLICATION EQ 'FUNDS.TRANSFER' AND AF EQ FIELD.NO THEN

        L.AC.AV.BALANCE = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS>
    END

RETURN

END
