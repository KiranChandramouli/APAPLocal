* @ValidationCode : MjotMTI0MTAwNzU1MTpDcDEyNTI6MTcwMjk4ODMyMDI4NDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:48:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
*19-12-2023               Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
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
*R22 Manual Code Conversion_Utility Check-Start
*       CALL System.setVariable(MOB.USER.VARIABLES<I, 1>, MOB.USER.VARIABLES<I, 2>)
        Y.MOB.USER.VARIABLES1 = MOB.USER.VARIABLES<I, 1>
        Y.MOB.USER.VARIABLES2 = MOB.USER.VARIABLES<I, 2>
        CALL System.setVariable(Y.MOB.USER.VARIABLES1, Y.MOB.USER.VARIABLES2)
*R22 Manual Code Conversion_Utility Check-End
    NEXT I


    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)



RETURN
