* @ValidationCode : MjotNTk3NjkyMDg3OkNwMTI1MjoxNjg0ODQyMTAxMTA0OklUU1M6LTE6LTE6LTE1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FORMAT.MESSAGE(Y.MESSAGE,Y.DATA.ORDER,Y.VALUES,Y.MESSAGE.FORMAT)
*----------------------------------------------------------------------
* Description : This routine is to format the message to left align.
* Input  Arg  : MESSAGE,LINE.LENGTH
* Output Arg  : MESSAGE.FORMAT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*   Date            Who                   Reference               Description
* 27 Dec 2011   H Ganesh                PACS00170056 - B.16      Initial Draft
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            VM TO @VM, ++ TO +=
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.MESSAGE.FORMAT = Y.MESSAGE
    Y.LOOP.CNT = DCOUNT(Y.DATA.ORDER,@VM)

    Y.LOOP = 1
    LOOP
    WHILE Y.LOOP LE Y.LOOP.CNT
        Y.DATA = Y.DATA.ORDER<1,Y.LOOP>
        GOSUB CHECK.VALUE
        Y.MESSAGE.FORMAT = EREPLACE (Y.MESSAGE.FORMAT,"&",Y.REPLACE.VAL,1,1)
        Y.LOOP += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN
*-----------------------------------------------------------------------------
CHECK.VALUE:
*-----------------------------------------------------------------------------

    BEGIN CASE
        CASE Y.DATA EQ 'DATE'
            Y.REPLACE.VAL = Y.VALUES<1>
        CASE Y.DATA EQ 'LOANNUMBER'
            Y.REPLACE.VAL = Y.VALUES<2>
        CASE Y.DATA EQ 'OLDRATE'
            Y.REPLACE.VAL = Y.VALUES<3>
        CASE Y.DATA EQ 'NEWRATE'
            Y.REPLACE.VAL = Y.VALUES<4>
        CASE Y.DATA EQ 'NEWAMOUNT'
            Y.REPLACE.VAL = Y.VALUES<5>
    END CASE
RETURN
END
