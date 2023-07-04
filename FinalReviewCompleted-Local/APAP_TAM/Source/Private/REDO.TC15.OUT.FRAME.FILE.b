* @ValidationCode : MjoyMDEyMzMzMjQ1OkNwMTI1MjoxNjgzMDE4MDk1MjU0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:35
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
SUBROUTINE  REDO.TC15.OUT.FRAME.FILE
**--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC15.OUT.FRAME.FILE
*Date              : 08.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
*Description:
*-------------
*This is a batch job will be attached as POST job service in order to generate the final
*sequence outgoing file and place in the same path
*FILE destination path,FILE name,Maximum lines from one trailer to another Trailer lines
*will be mentioned in DETAILS field of BATCH
*---------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*08/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - added APAP.TAM
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
	$USING APAP.TAM

    GOSUB INIT
    GOSUB PROCESS

RETURN


*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------

    FN.VISA.OUT.CHGBCK.LINES='F.VISA.OUT.CHGBCK.LINES'
    F.VISA.OUT.CHGBCK.LINES=''
    CALL OPF(FN.VISA.OUT.CHGBCK.LINES,F.VISA.OUT.CHGBCK.LINES)

    FN.REDO.VISA.STLMT.PARAM='F.REDO.VISA.STLMT.PARAM'
    REDO.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.VISA.STLMT.PARAM,REDO.ID,R.REDO.VISA.STLMT.PARAM,REDO.ERR)

    Y.FILE.NAME=BATCH.DETAILS<3,1,1>
    Y.FILE.PATH=BATCH.DETAILS<3,1,2>
*Y.MAX.LINE.PER.HEADER=BATCH.DETAILS<3,1,3>
    Y.MAX.LINE.PER.HEADER=R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.MAX.LINE>

    TOT.AMT='0'
    NO.MON.TXN=''
    TRAILER.TRACE='FALSE'
    BATCH.NUMBER=''
    AMT.TXN='0'
    TOT.NO.MON.TXN='0'
    NO.MON.TXN='0'
    NO.NO.MON.TXN='0'
    NO.OF.BATCH=1
    NO.OF.TCR='0'
    TOTAL.LINE='0'
    TRAILER.LINE=''
    BATCH.TRAILER=''
    FILE.TRAILER=''


RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    Y.FILE.ID='FILE.SEQ'
    CALL F.READ(FN.VISA.OUT.CHGBCK.LINES,Y.FILE.ID,R.FILE.SEQ,F.VISA.OUT.CHGBCK.LINES,SEQ.ERR)


    IF R.FILE.SEQ EQ '' THEN
        Y.SEQ.NO=1
    END ELSE
        IF R.FILE.SEQ<1> EQ TODAY THEN
            Y.SEQ.NO=R.FILE.SEQ<2>
            Y.SEQ.NO += 1 ;* R22 Auto conversion
        END ELSE
            Y.SEQ.NO=1
        END
    END

    R.FILE.SEQ<2>=Y.SEQ.NO
    R.FILE.SEQ<1>=TODAY

    Y.FILE.NAME=Y.FILE.NAME:'_':TODAY:'_':Y.SEQ.NO:'.ctf'

    OPENSEQ Y.FILE.PATH,Y.FILE.NAME TO Y.FILE ELSE
        CREATE Y.FILE ELSE
            CALL OCOMO("Unable to create file ":Y.FILE)
        END
    END
*WRITESEQ R.FILE.SEQ TO F.VISA.OUT.CHGBCK.LINES,Y.FILE.ID ELSE
*CALL OCOMO("Unable to write into the file ":Y.FILE)
*END
    CALL F.WRITE(FN.VISA.OUT.CHGBCK.LINES,Y.FILE.ID,R.FILE.SEQ)

    SEL.FILE="SELECT ":FN.VISA.OUT.CHGBCK.LINES:" WITH @ID UNLIKE FILE.SEQ..."
    CALL EB.READLIST(SEL.FILE,Y.FILE.LIST,'', NO.FILES,FILE.CODE)
    IF Y.FILE.LIST NE '' THEN
        GOSUB PROCESS.FILES
    END

RETURN
*------------------------------------------------------------------------------------
PROCESS.FILES:
*------------------------------------------------------------------------------------
*CALL REDO.FRAME.FILE.HEADER
    CALL APAP.TAM.redoFrameFileHeader() ;* R22 Manual conversion
    FILE.HEADER =FILE.HEADER:CHARX(13)

    WRITESEQ FILE.HEADER TO Y.FILE ELSE
        CALL OCOMO("Unable to write into the file ":Y.FILE)
    END

    LOOP
        REMOVE Y.FILE.ID FROM Y.FILE.LIST SETTING Y.FILE.POS
    WHILE Y.FILE.ID:Y.FILE.POS
        GOSUB PROCESS.EACH.FILE
        CALL F.DELETE(FN.VISA.OUT.CHGBCK.LINES,Y.FILE.ID)
    REPEAT
*IF BATCH.TRAILER EQ '' AND TRAILER.TRACE EQ 'FALSE' THEN

    BATCH.NUMBER += 1 ;* R22 Auto conversion
    TC.CODE=91
*CALL REDO.FRAME.BATCH.TRAILER
    CALL APAP.TAM.redoFrameBatchTrailer() ;* R22 Manual conversion
    BATCH.TRAILER=BATCH.TRAILER:CHARX(13)
    WRITESEQ BATCH.TRAILER TO Y.FILE ELSE
        CALL OCOMO("Unable to write into the file ":Y.FILE)
    END
    BATCH.TRAILER=''

    TOT.AMT += AMT.TXN ;* R22 Auto conversion
    AMT.TXN=0
    TOT.NO.MON.TXN += NO.MON.TXN ;* R22 Auto conversion
    NO.MON.TXN=0
*NO.OF.BATCH++
    NO.OF.TCR += TOTAL.LINE ;* R22 Auto conversion
    TOTAL.LINE=0
*END

    TC.CODE=92
*CALL REDO.FRAME.FILE.TRAILER
    CALL APAP.TAM.redoFrameFileTrailer() ;* R22 Manual conversion

    FILE.TRAILER=FILE.TRAILER:CHARX(13)
    WRITESEQ FILE.TRAILER TO Y.FILE ELSE
        CALL OCOMO("Unable to write into the file ":Y.FILE)
    END
RETURN

*------------------------------------------------------------------------------------
PROCESS.EACH.FILE:
*------------------------------------------------------------------------------------
* In This para each file is processed
* Y.FILE.ID   - Variable holds the File Name

    IF TRAILER.TRACE EQ 'TRUE' THEN

        TRAILER.TRACE='FALSE'
        BATCH.NUMBER += 1 ;* R22 Auto conversion
        TC.CODE=91
*CALL REDO.FRAME.BATCH.TRAILER
        CALL APAP.TAM.redoFrameBatchTrailer() ;* R22 Manual conversion
        BATCH.TRAILER=BATCH.TRAILER:CHARX(13)
        WRITESEQ BATCH.TRAILER TO Y.FILE ELSE
            CALL OCOMO("Unable to write into the file ":Y.FILE)
        END
        BATCH.TRAILER=''

        TOT.AMT += AMT.TXN ;* R22 Auto conversion
        AMT.TXN=0
        TOT.NO.MON.TXN += NO.MON.TXN ;* R22 Auto conversion
        NO.MON.TXN=0
        NO.OF.BATCH += 1 ;* R22 Auto conversion
        NO.OF.TCR += TOTAL.LINE ;* R22 Auto conversion
        TOTAL.LINE=0
    END

    CALL F.READ(FN.VISA.OUT.CHGBCK.LINES,Y.FILE.ID,R.VISA.OUT.CHGBCK.LINES,F.VISA.OUT.CHGBCK.LINES,CHRGBCK.ERR)
    NO.OF.FILE.LINES=DCOUNT(R.VISA.OUT.CHGBCK.LINES,@FM)
    GOSUB WRITE.FILE
    IF (Y.MAX.LINE.PER.HEADER-10) LE TOTAL.LINE THEN
        TRAILER.TRACE='TRUE'

    END


RETURN

*------------------------------------------------------------------------------------
WRITE.FILE:
*------------------------------------------------------------------------------------
* Here each line of fine is read is written to Main File

    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.FILE.LINES
        Y.STLMT.LINE=R.VISA.OUT.CHGBCK.LINES<Y.VAR1> :CHARX(13)
        WRITESEQ Y.STLMT.LINE TO Y.FILE ELSE
            CALL OCOMO("Unable to write into the file ":Y.FILE)
        END
        IF Y.STLMT.LINE[4,1] EQ 0 THEN
            TXN.CODE=Y.STLMT.LINE[1,2]
            LOCATE TXN.CODE IN R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.TXN.CODE,1> SETTING TXN.POS THEN

                Y.START.POS='' ; Y.LEN = ''
                Y.START.POS=R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.SRC.AMT.STRTPOS,TXN.POS>
                Y.LEN=R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.SRC.AMT.LEN,TXN.POS>
                IF Y.START.POS NE '' AND Y.LEN NE '' THEN
                    AMT.TXN=AMT.TXN+Y.STLMT.LINE[Y.START.POS,Y.LEN]
                END
            END
            IF Y.STLMT.LINE[1,2] NE '52' AND Y.STLMT.LINE[1,2] NE '40' THEN

                NO.MON.TXN += 1 ;* R22 Auto conversion
            END ELSE
                NO.NO.MON.TXN += 1 ;* R22 Auto conversion
            END
        END
        TOTAL.LINE += 1 ;* R22 Auto conversion

        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
