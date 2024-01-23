* @ValidationCode : MjozMDU3MDgyNzU6Q3AxMjUyOjE3MDM1ODYwNzIxNTc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:51:12
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
SUBROUTINE REDO.B.ESM.STATUS.UPD(Y.REDO.T.MSG.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.ESM.STATUS.UPD
*--------------------------------------------------------------------------------
* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
*Modification History:
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 09 AUG 2011    Prabhu N      PACS00100804      routine for the updating secure message status to UNREAD
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - FM TO @FM AND ++ TO += 1
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    Change F.READ to F.READU
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_REDO.B.ESM.STATUS.UPD.COMMON

    GOSUB INIT
RETURN
*------
INIT:
*------
    R.REDO.T.MSG=''
    CALL F.READ(FN.REDO.T.MSG.DET,Y.REDO.T.MSG.ID,R.REDO.T.MSG,F.REDO.T.MSG.DET,ERR)
    Y.ESM.LIST=R.REDO.T.MSG
    Y.ESM.TOT.CNT=DCOUNT(Y.ESM.LIST,@FM)
    Y.ESM.ST.CNT=1
    LOOP
    WHILE Y.ESM.ST.CNT LE Y.ESM.TOT.CNT
        Y.ESM.ID=Y.ESM.LIST<Y.ESM.ST.CNT>
        Y.ESM.ST.CNT += 1
*        CALL F.READ(FN.EB.SECURE.MESSAGE,Y.ESM.ID,R.ESM.REC,F.EB.SECURE.MESSAGE,ERR)
        CALL F.READU(FN.EB.SECURE.MESSAGE,Y.ESM.ID,R.ESM.REC,F.EB.SECURE.MESSAGE,ERR,"") ;*R22 Manual Conversion
        IF NOT(ERR) THEN
            R.ESM.REC<EB.SM.TO.STATUS>='UNREAD'
            CALL F.WRITE(FN.EB.SECURE.MESSAGE,Y.ESM.ID,R.ESM.REC)
        END
    REPEAT
RETURN
END
