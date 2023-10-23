* @ValidationCode : MjotMTgwNDQxOTM1OTpDcDEyNTI6MTY5ODA0MzM4Mzc4NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Oct 2023 12:13:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
*-----------------------------------------------------------------------------
* <Rating>90</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE B.AMEND.SERVICE.ITEMS
********************************************************************************
* 25/08/2016 - Eashwar - ITSS
* This utility job will help to automatically increase/decrease agents, sleep timing, death watch and to start/stop
* any TSA.SERVICE during COB
********************************************************************************
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*14/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*14/09/2023      Suresh                     R22 Manual Conversion           SM TO @SM
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.WORKLOAD.PROFILE
    $INSERT I_F.TSA.PARAMETER
    $INSERT I_F.TSA.SERVICE

    YCNT = DCOUNT(BATCH.DETAILS<3,1>,@SM)

    FOR I = 1 TO YCNT
        YFIRST.VALUE = FIELD(BATCH.DETAILS<3,1,I>," ",1)

        BEGIN CASE
            CASE YFIRST.VALUE EQ "CWL"
                YFILE = "F.TSA.WORKLOAD.PROFILE" ; YFIELD.NO = TS.WLP.AGENTS.REQUIRED
                YRECORD = FIELD(BATCH.DETAILS<3,1,I>," ",2)
                YVALUE = FIELD(BATCH.DETAILS<3,1,I>," ",3)

            CASE YFIRST.VALUE EQ "SLEEP"
                YFILE = "F.TSA.PARAMETER" ; YFIELD.NO = TS.PARM.REVIEW.TIME
                YRECORD = "SYSTEM"

            CASE YFIRST.VALUE EQ "DW"
                YFILE = "F.TSA.PARAMETER" ; YFIELD.NO = TS.PARM.DEATH.WATCH
                YRECORD = "SYSTEM"
                YVALUE = FIELD(BATCH.DETAILS<3,1,I>," ",2)

            CASE YFIRST.VALUE EQ "STOP" OR YFIRST.VALUE EQ "START"
                YFILE = "F.TSA.SERVICE" ; YFIELD.NO = TS.TSM.SERVICE.CONTROL
                YRECORD = FIELD(BATCH.DETAILS<3,1,I>," ",2)
                YVALUE = YFIRST.VALUE
            CASE 1
                CONTINUE
        END CASE
        GOSUB PROCESS
    NEXT I

RETURN

*======*
PROCESS:
*======*
    OPEN YFILE TO F.FILE ELSE F.FILE = ''

    READ R.REC FROM F.FILE,YRECORD THEN
        IF YFIRST.VALUE EQ 'SLEEP' THEN
            YVALUE = R.REC<YFIELD.NO> * 2
            SLEEP YVALUE
        END ELSE
            R.REC<YFIELD.NO> = YVALUE
            WRITE R.REC TO F.FILE,YRECORD
        END
    END

RETURN

END
