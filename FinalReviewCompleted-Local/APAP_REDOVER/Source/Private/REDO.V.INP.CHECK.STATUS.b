* @ValidationCode : MjoxMzM2MDM2NzAxOkNwMTI1MjoxNjgyNDEyMzQ4ODE4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:48
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


    LREF.POS=''
    CALL GET.LOC.REF('TELLER','L.TT.CR.CRD.STS',LREF.POS)


    FN.REDO.INTERFACE.PARAMETER='F.REDO.INTERFACE.PARAMETER'
    F.REDO.INTERFACE.PARAMETER=''
    CALL OPF(FN.REDO.INTERFACE.PARAMETER,F.REDO.INTERFACE.PARAMETER)

    CALL F.READ(FN.REDO.INTERFACE.PARAMETER,'SUNNEL',R.INTERFACE.PARAM,F.REDO.INTERFACE.PARAMETER,ERR)
    VAR.STATUS=R.INTERFACE.PARAM<IN.CREDIT.STATUS>

    IF R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS> EQ VAR.STATUS THEN
        VAR.CURR.NO=R.NEW(TT.TE.CURR.NO)
        TEXT="REDO.CREDIT.STATUS"
        CALL STORE.OVERRIDE(VAR.CURR.NO)
    END
RETURN
