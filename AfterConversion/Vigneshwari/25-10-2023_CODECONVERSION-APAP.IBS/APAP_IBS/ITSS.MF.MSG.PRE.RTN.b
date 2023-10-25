* @ValidationCode : Mjo2NDYyODI4Mzk6Q3AxMjUyOjE2OTgyMzczNjM5ODU6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:06:03
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
    SUBROUTINE ITSS.MF.MSG.PRE.RTN(LOC.REQUEST)
*---------------------------------------------------------------------------------------------------
* Description: This is a MSG.PRE.RTN routine used for mobile OFS.SOURCE record to switch OPERATOR
*              as EB.EXTERNAL.USER rather than normal USER.

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                No changes
*-----------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.MOB.FRMWRK.COMMON 
    $INSERT I_EB.EXTERNAL.COMMON
*---------------------------------------------------------------------------------------------------

    IF INDEX(LOC.REQUEST, 'USER.ID', 1) THEN

        EXT.LOC.REQUEST = LOC.REQUEST[',', 5, 9999]
        GEN.INFO.CNT = COUNT(EXT.LOC.REQUEST, '=')

        FOR I=1 TO GEN.INFO.CNT
            GEN.VAL = EXT.LOC.REQUEST[',', I, 1]
            IF GEN.VAL['=', 1, 1] EQ 'USER.ID' THEN
                EXT.USER.ID=GEN.VAL['=',2,1]
                OPERATOR = EXT.USER.ID 
            END
        NEXT I
    END

    IF EXT.USER.ID THEN
        OPERATOR = EXT.USER.ID 
        EB.EXTERNAL$USER.ID = EXT.USER.ID
        CALL System.loadVariables
    END 


    RETURN

*---------------------------------------------------------------------------------------------------
END
