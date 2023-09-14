* @ValidationCode : MjoxMTU0MjMzMjI1OkNwMTI1MjoxNjgwNzgxMjc4OTU5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:11:18
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUDIT.LOG.BULK(Y.ID)

    $INSERT I_TSA.COMMON  ;*R22 AUTO CONVERSTION I_COMMON TO I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON
    $INSERT I_BATCH.FILES
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER AND I_COMMON TO I_TSA.COMMON AND FM TO @FM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------


    CALL F.READ(FN.REDO.AUDIT.TRAIL.LOG,Y.ID,R.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG,LOG.ERR)

    IF NOT(R.REDO.AUDIT.TRAIL.LOG) THEN
        RETURN
    END

    R.REDO.AUDIT.TRAIL.LOG = CHANGE(R.REDO.AUDIT.TRAIL.LOG,@FM,Y.DELIM)

    Y.FILE.NAME = AGENT.NUMBER:TODAY:'SEP' ;* R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER

    READ Y.REC FROM Y.PTR,Y.FILE.NAME THEN
        Y.REC<-1> = R.REDO.AUDIT.TRAIL.LOG

        WRITE Y.REC ON Y.PTR,Y.FILE.NAME ON ERROR
*TUS-Convert cannot find the OPEN or OPF , not converted WRITE to F.WRITE
            CALL OCOMO("UNABLE TO WRITE REDO.AUDIT.TRAIL.LOG ":Y.ID)
        END
    END

END
