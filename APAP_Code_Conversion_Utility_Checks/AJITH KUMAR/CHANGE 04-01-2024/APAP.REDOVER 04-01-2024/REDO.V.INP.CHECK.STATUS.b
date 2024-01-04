* @ValidationCode : Mjo2ODAyNTA2ODpDcDEyNTI6MTcwNDM2Mzg1ODk0MTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jan 2024 15:54:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHECK.STATUS
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :PRABHU.N
*Program Name :REDO.V.INP.CHECK.STATUS
*---------------------------------------------------------------------------------

*DESCRIPTION :It is attached as authorization routine in all the version used
* in the development N.83.If Credit card status is Back log then it will
* show an override message
*LINKED WITH :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
* Date who Reference Description
* 16-APR-2010 Prabhu.N ODR-2009-10-0526 Initial Creation
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.INTERFACE.PARAMETER
    $USING EB.LocalReferences


    LREF.POS=''
*CALL GET.LOC.REF('TELLER','L.TT.CR.CRD.STS',LREF.POS)
    EB.LocalReferences.GetLocRef('TELLER','L.TT.CR.CRD.STS',LREF.POS);* R22 AUTO CONVERSION


    FN.REDO.INTERFACE.PARAMETER='F.REDO.INTERFACE.PARAMETER'
    F.REDO.INTERFACE.PARAMETER=''
    CALL OPF(FN.REDO.INTERFACE.PARAMETER,F.REDO.INTERFACE.PARAMETER)

*CALL F.READ(FN.REDO.INTERFACE.PARAMETER,'SUNNEL',R.INTERFACE.PARAM,F.REDO.INTERFACE.PARAMETER,ERR)
    IDVAR.1 = 'SUNNEL' ;* R22 AUTO CONVERSION
    CALL F.READ(FN.REDO.INTERFACE.PARAMETER,IDVAR.1,R.INTERFACE.PARAM,F.REDO.INTERFACE.PARAMETER,ERR);* R22 AUTO CONVERSION
    VAR.STATUS=R.INTERFACE.PARAM<IN.CREDIT.STATUS>

    IF R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS> EQ VAR.STATUS THEN
        VAR.CURR.NO=R.NEW(TT.TE.CURR.NO)
        TEXT="REDO.CREDIT.STATUS"
        CALL STORE.OVERRIDE(VAR.CURR.NO)
    END
RETURN
