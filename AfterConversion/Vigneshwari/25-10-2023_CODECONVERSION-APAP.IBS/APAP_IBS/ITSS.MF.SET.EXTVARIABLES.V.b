* @ValidationCode : Mjo0OTkwMDU1MjY6Q3AxMjUyOjE2OTgyMzc2NzY2ODk6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:11:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.SET.EXTVARIABLES.V


*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON

*    FN.EB.USER.CONTEXT = 'F.EB.USER.CONTEXT'
*    F.EB.USER.CONTEXT = ''
*    CALL OPF(FN.EB.USER.CONTEXT, F.EB.USER.CONTEXT)

*    E.EB.USER.CONTEXT = ''
*    CALL F.READ(FN.EB.USER.CONTEXT, OPERATOR, R.EB.USER.CONTEXT, F.EB.USER.CONTEXT, E.EB.USER.CONTEXT)
*    Y.USER = EB.EXTERNAL$USER.ID
*    IF NOT(E.EB.USER.CONTEXT) THEN
*        FOR I=1 TO  DCOUNT(R.EB.USER.CONTEXT<1>,VM)
*            CALL System.setVariable(R.EB.USER.CONTEXT<1,I, 1>, R.EB.USER.CONTEXT<2,I>)
*        NEXT I
*    END

    *DEBUG
    USRVARSCNT = DCOUNT(MOB.USER.VARIABLES, @FM)
    FOR I=1 TO USRVARSCNT
        CALL System.setVariable(MOB.USER.VARIABLES<I, 1>, MOB.USER.VARIABLES<I, 2>)
    NEXT I


    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)



    RETURN
