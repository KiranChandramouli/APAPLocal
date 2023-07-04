* @ValidationCode : MjotNzY1MDU5Njg5OkNwMTI1MjoxNjgxMTkzOTMzODY0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISA.STLMT.PARAM.PROCESS
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VI.VISA.APPROVE
***********************************************************************************
*Description:  This is process routine for param table REDO.VISA.STLMT.PARAM



*****************************************************************************
*linked with: REDO.VISA.STLMT.PARAM
*In parameter: NA
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO                 REFERENCE         DESCRIPTION
*03.12.2010   BALA GURUNATHAN       ODR-2010-08-0469  INITIAL CREATION
* 11.04.2023  Conversion Tool       R22               Auto Conversion     - VM TO @VM, SM TO @SM, ++ TO += 1
* 11.04.2023  Shanmugapriya M       R22               Manual Conversion   - No changes
*
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.MERCHANT.TYPE



    GOSUB INIT
    GOSUB PROCESS


RETURN

*-----------------
PROCESS:
*-----------------


    MERCHANT.TYPE=R.NEW(VISA.STM.PARAM.MERCH.NO.AMT.VAL)


    Y.MERCH.VM=DCOUNT(MERCHANT.TYPE,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.MERCH.VM
        Y.MERCH.SM.VALUE=MERCHANT.TYPE<1,Y.VAR1>
        Y.MERCHSM=DCOUNT(Y.MERCH.SM.VALUE,@SM)
        Y.VAR2=1
        LOOP
        WHILE Y.VAR2 LE Y.MERCHSM
            Y.MERCH.CODE=MERCHANT.TYPE<1,Y.VAR1,Y.VAR2>
            LOCATE Y.MERCH.CODE IN R.REDO.MERCHANT.TYPE<REDO.MERCHANT.TYPE.MERCHANT.TYPE,1> SETTING POS ELSE
                AF=VISA.STM.PARAM.MERCH.NO.AMT.VAL
                AV=Y.VAR1
                AS=Y.VAR2
                ETEXT='ST-NOT.VALID.MRCHNT.TYP'
                CALL STORE.END.ERROR
                ETEXT=''
                BREAK
            END

            Y.VAR2 += 1              ;** R22 Auto conversion - ++ TO += 1
        REPEAT
        Y.VAR1 += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*-----------------
INIT:
*-----------------

    FN.REDO.MERCHANT.TYPE='F.REDO.MERCHANT.TYPE'
    CALL CACHE.READ(FN.REDO.MERCHANT.TYPE,'SYSTEM',R.REDO.MERCHANT.TYPE,MRCHNT.ERR)
RETURN

END
