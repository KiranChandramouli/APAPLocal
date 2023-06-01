* @ValidationCode : MjoxNDQ0NDI4NjA4OkNwMTI1MjoxNjg0MjIyODMwNDQ0OklUU1M6LTE6LTE6ODc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 87
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, ++ TO +=, INCLUDE TO INSERT
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.E.BLD.EXE.ACCT.OPEN(ENQ.DATA)

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.DATES ;*AUTO R22 CODE CONVERSION - END


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    YL.TODAY = ''; SYSD.POS = ''; YTP.COMI = ''; SYSD.POS = ''
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

PROCESS:
********
    LOCATE "OPENING.DATE" IN ENQ.DATA<2,1> SETTING SYSD.POS1 THEN
        IF ENQ.DATA<4,SYSD.POS1> EQ '' THEN
            ENQ.DATA<4,SYSD.POS1> = LAST.WORK.DAY
        END
    END

    IF RUNNING.UNDER.BATCH EQ 1 THEN
        SYSD.POS = 0
        SYSD.POS = DCOUNT(ENQ.DATA<2>,@VM)
        IF SYSD.POS EQ 0 THEN
            SYSD.POS = 1
        END ELSE
            SYSD.POS += 1 ;*AUTO R22 CODE CONVERSION
        END
        ENQ.DATA<2,SYSD.POS> = "SYSTEM.DATE"
        ENQ.DATA<3,SYSD.POS> = "EQ"
        ENQ.DATA<4,SYSD.POS> = LAST.WORK.DAY
    END
RETURN

END
