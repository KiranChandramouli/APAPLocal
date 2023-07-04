* @ValidationCode : MjoxMTY2Nzk4NTQ1OkNwMTI1MjoxNjg0ODQyMTUwODIxOklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.VISA.INITIAL.PROCESS.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.INITIAL.PROCESS.SELECT
*Date              : 23.11.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*07 Oct 2011     Balagurunathan              PACS00126440    Added file validation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL routine format modified
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.FILE.DETAILS
    $INSERT I_F.REDO.VISA.PROCESS.INFO
    $INSERT I_REDO.VISA.INITIAL.PROCESS.COMMON
    $USING APAP.REDOCHNLS

    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    Y.FIN.FILES.NAME=''
    SEL.CMD="SELECT ":FN.REDO.VISA.STLMT.FILE.DETAILS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.SEL,SEL.ERR)

    LOOP
        REMOVE Y.FILE.NAME FROM SEL.LIST SETTING SEL.POS
    WHILE Y.FILE.NAME:SEL.POS
        Y.FILENAME.LEN=LEN(Y.FILE.NAME)
        CALL F.READ(FN.REDO.VISA.STLMT.FILE.DETAILS,Y.FILE.NAME,R.REDO.VISA.STLMT.FILE.DETAILS,F.REDO.VISA.STLMT.FILE.DETAILS,Y.VISA.ERR)
        Y.FILE.PATH=R.REDO.VISA.STLMT.FILE.DETAILS<STMT.FILE.FILE.PATH>
        CHANGE @VM TO '' IN Y.FILE.PATH
        SEL.FILE="SELECT ":Y.FILE.PATH:" WITH @ID LIKE ":Y.FILE.NAME:"..."
        CALL EB.READLIST(SEL.FILE,Y.FILE.LIST,'',NO.SELL,SELL.ERR)
        LOOP
            REMOVE Y.FILES.NAME FROM Y.FILE.LIST  SETTING SELL.POS
        WHILE Y.FILES.NAME:SELL.POS
            DATE.NAME=Y.FILES.NAME[Y.FILENAME.LEN+2,8]
            COMI=DATE.NAME
            CALL IN2D("12","D")
            FLAG.FAIL=0
            IF ETEXT THEN
                CALL OCOMO(DATE.NAME : " IS NOT A VALID FILE NAME IN FILE " : Y.FILES.NAME )

                REC.CON ='INVALID FILE NAME'
                DESC    = 'INVALID FILE NAME'
                GOSUB LOG.ERROR.C22

                PATH.BCK=BATCH.DETAILS<3,1,1>

                MOVE.CMD="mv " : Y.FILE.PATH:"/":Y.FILES.NAME : " " :PATH.BCK : "/BCK." : Y.FILES.NAME
                EXECUTE MOVE.CMD
                FLAG.FAIL=1
            END

            IF Y.FILES.NAME[Y.FILENAME.LEN+2,8] LE TODAY AND FLAG.FAIL NE 1 THEN
                Y.FIN.FILES.NAME<-1>=Y.FILES.NAME:"*":Y.FILE.PATH
            END

        REPEAT
    REPEAT

    CALL BATCH.BUILD.LIST('',Y.FIN.FILES.NAME)
RETURN


*-----------------------------------------------------------------------------
LOG.ERROR.C22:
*-----------------------------------------------------------------------------

    MON.TP='04'
    INT.CODE = 'VIS001'
    INT.TYPE = 'BATCH'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
RETURN

END
