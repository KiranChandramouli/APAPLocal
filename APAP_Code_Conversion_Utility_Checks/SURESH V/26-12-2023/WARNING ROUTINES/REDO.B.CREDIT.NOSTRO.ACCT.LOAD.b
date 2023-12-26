* @ValidationCode : MjotMTQzNjM0NDMyNTpDcDEyNTI6MTcwMzU2OTY0MDgwODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 11:17:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CREDIT.NOSTRO.ACCT.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CREDIT.NOSTRO.ACCT.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.CREDIT.NOSTRO.ACCT
* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                  R22 Manual Conversion  IDVAR Variable Changed
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TAX
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_REDO.B.CREDIT.NOSTRO.ACCT.COMMON

    FN.REDO.MANAGER.CHQ.PARAM='F.REDO.MANAGER.CHQ.PARAM'
    F.REDO.MANAGER.CHQ.PARAM=''
    CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)

    FN.REDO.MANAGER.CHQ.DETAILS='F.REDO.MANAGER.CHQ.DETAILS'
    F.REDO.MANAGER.CHQ.DETAILS=''
    CALL OPF(FN.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS)
    FN.TAX='F.TAX'
    F.TAX=''
    CALL OPF(FN.TAX,F.TAX)

    FN.FT.COM.TYPE= 'F.FT.COMMISSION.TYPE'
    F.FT.COM.TYPE = ''
    CALL OPF(FN.FT.COM.TYPE,F.FT.COM.TYPE)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)
    CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,IDVAR,R.CHQ.PARAM,ERR) ;*R22 Manual Conversion


    LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN
END
