* @ValidationCode : MjotMzU5NTMyNzE0OkNwMTI1MjoxNjgyNDEyMzYxNzMzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.GET.CUS.ENRI

*----------------------------------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : VIGNESH KUMAAR M R
* Program Name : REDO.V.INP.VERIFY.STAFF
*----------------------------------------------------------------------------------------------------------------------
* This routine is used to modify the enrichment for the liquidation account per the requirement
*----------------------------------------------------------------------------------------------------------------------
* Linked with : VERSION.CONTROL of APAP.H.GARNISH.DETAILS TABLE
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*----------------------------------------------------------------------------------------------------------------------
* DATE NAME Refernce DESCRIPTION
* 14-04-2013 Vignesh Kumaar R PACS00266089 To display the enrichment for CLIENTE field
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     No changes
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
   $USING EB.LocalReferences

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

*    CALL GET.LOC.REF('TELLER','L.TT.CLIENT.NME',L.TT.CLIENT.NME.POS)
EB.LocalReferences.GetLocRef('TELLER','L.TT.CLIENT.NME',L.TT.CLIENT.NME.POS);* R22 UTILITY AUTO CONVERSION

    IF COMI NE '' THEN

        CALL F.READ(FN.CUSTOMER,COMI,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS> = R.CUSTOMER<EB.CUS.SHORT.NAME>

    END ELSE
        R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CLIENT.NME.POS> = ''
    END

RETURN
