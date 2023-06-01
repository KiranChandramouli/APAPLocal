* @ValidationCode : Mjo5MDU4NDI2NTg6Q3AxMjUyOjE2ODU1MzYwMzQwNDU6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.STO.UPD.SUNNEL(Y.FT.ID,Y.FT.STATUS)
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.STO.UPD.SUNNEL.DETAILS
*------------------------------------------------------------------------------------------------------------------
*Description       :This routine updates sunnel after FT is executed
*Linked With       :
*In  Parameter     :
*Out Parameter     :
*ODR  Number       : 2010-08-0031
*Modification history
*Date                Who               Reference                  Description
*18-04-2023      conversion tool     R22 Auto code conversion     No changes
*18-04-2023      Mohanraj R          R22 Manual code conversion   CALL method format modified
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $USING APAP.TAM

    IF Y.FT.STATUS EQ 'IHLD' THEN
        RETURN
    END
    GOSUB INIT
RETURN
*-------------------------------------------------------------
*********
INIT:
*********

    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR)
    MATPARSE R.NEW FROM R.FUNDS.TRANSFER
    IF R.NEW(FT.CREDIT.CURRENCY) EQ 'DOP' THEN
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.DOP'
    END
    ELSE
        Y.ARRAY='BE_P_PAGOS_SUNNEL_T24.FT.USD'
    END
    PGM.VERSION='FUNDS.TRANSFER'
    APPLICATION='FUNDS.TRANSFER'
    APAP.REDOVER.REDO.V.WRAP.SUNNEL(Y.ARRAY) ;* R22 Manual Conversion - CALL method format modified
    MATBUILD R.FUNDS.TRANSFER FROM R.NEW
    Y.ID.NEW=ID.NEW
    APAP.TAM.redoStoNcf(Y.ID.NEW,R.FUNDS.TRANSFER) ;* R22 Manual Conversion - CALL method format modified
RETURN
END
