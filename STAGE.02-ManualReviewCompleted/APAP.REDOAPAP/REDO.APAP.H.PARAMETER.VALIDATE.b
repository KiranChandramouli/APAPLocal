* @ValidationCode : MjoyMDIwMDI3OTExOkNwMTI1MjoxNjgwNjc3NDkzMDQyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:21:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE  REDO.APAP.H.PARAMETER.VALIDATE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.APAP.H.PARAMETER.VALIDATE
*Date              : 09.12.2010
*Description       : This routine is to validate the REDO.APAP.H.PARAMETER table
*
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date               Name                   Reference            Version
* -------            ----                   ----------           --------
* 26-Nov-2018        Vignesh Kumaar M R     CI#2795720           BRD001 - FAST FUNDS SERVICES
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM AND I TO I.VAR AND ++ TO += 1
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.H.PARAMETER

    IF R.NEW(PARAM.OCT.FF.ACCT) NE '' THEN

        GET.OCT.FF.ACCT.CNT = DCOUNT(R.NEW(PARAM.OCT.FF.ACCT),@VM)
        GET.OCT.FF.DOP.ACCT = R.NEW(PARAM.OCT.DOP.ACCT)
        GET.OCT.FF.USD.ACCT = R.NEW(PARAM.OCT.USD.ACCT)

        I.VAR = 1

        LOOP
        WHILE I.VAR LE GET.OCT.FF.ACCT.CNT
            IF GET.OCT.FF.DOP.ACCT<1,I.VAR> EQ '' THEN
                AF = PARAM.OCT.DOP.ACCT
                AV = I.VAR
                ETEXT = "EB-INPUT.MISSING"
                CALL STORE.END.ERROR
            END

            IF GET.OCT.FF.USD.ACCT<1,I.VAR> EQ '' THEN
                AF = PARAM.OCT.USD.ACCT
                AV = I.VAR
                ETEXT = "EB-INPUT.MISSING"
                CALL STORE.END.ERROR
            END
            I.VAR += 1  : ;*R22 AUTO CONVERSTION ++ TO += 1
        REPEAT

    END

RETURN
