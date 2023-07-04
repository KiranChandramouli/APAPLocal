* @ValidationCode : MjotODc4MjYwOTgwOkNwMTI1MjoxNjg0ODM2MDUxNzQ5OklUU1M6LTE6LTE6MjkyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 292
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.PARAM.PURGE(Y.PURGE.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TEMENOS DEVELOPMENT
* Program Name  : REDO.APAP.PARAM.PURGE
* ODR           : ODR-2011-03-0113
*------------------------------------------------------------------------------------------
*DESCRIPTION  : REDO.APAP.PARAM.PURGE Multithreading routine responsible for purging TT & FT records
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*14-04-2011         JANANI             ODR-2011-03-0113     INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
**********************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.COMMON
    $INSERT I_F.REDO.FT.HIS
    $INSERT I_F.REDO.TT.HIS
    $INSERT I_F.REDO.APAP.PARAM
    $INSERT I_BATCH.FILES

    GOSUB PROCESS
RETURN
*******
PROCESS:
**********
    IF CONTROL.LIST<1,1> NE '' THEN
        FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
        F.APPLICATION = ''
        CALL OPF(FN.APPLICATION,F.APPLICATION)
        CALL F.DELETE(FN.APPLICATION,Y.PURGE.ID)
    END
RETURN
END
*----------End of Program--------------------------------------------------------------------
