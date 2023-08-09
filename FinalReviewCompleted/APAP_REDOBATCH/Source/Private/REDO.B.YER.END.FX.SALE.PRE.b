<<<<<<< Updated upstream
* @ValidationCode : Mjo0MjI3MDYwMjc6Q3AxMjUyOjE2OTAyNjQ0NzMxNzY6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:24:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjotMTg5NzI1MjUyNjpDcDEyNTI6MTY4NDg1NDQwMjk2MzpJVFNTOi0xOi0xOjI2MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 261
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.YER.END.FX.SALE.PRE(Y.FX.ID)
*----------------------------------------------------------------------------------------------------------
* Description           : This Process routine is used to Process the details of Last Year Sales in Forex
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN21
*
* Attached To           : BATCH>BNK/REDO.B.YER.END.FX.SALE
*
* Attached As           : Batch Routine
*----------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*----------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*----------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*----------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*----------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes he
<<<<<<< Updated upstream
* Date                  who                   Reference
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION --1 TO -= 1
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.YER.END.FX.SALE.PRE.COMMON
    $INSERT I_F.FOREX
    $INSERT I_F.DATES
<<<<<<< Updated upstream
    $USING APAP.REDOCHNLS
=======
>>>>>>> Stashed changes
    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
*----
    Y.FX.ID.LAT = ''
RETURN
PROCESS:
*-------
    Y.FX.ID.LAT = FIELD(Y.FX.ID,";",1,1)
    CALL F.READ(FN.FOREX.LVE,Y.FX.ID.LAT,R.FOREX.LVE,F.FOREX.LVE,FOREX.ERR)
    IF NOT(R.FOREX.LVE) THEN
        GOSUB GET.FX.ID.HIST
        GOSUB WRITE.REDO.FILE
    END
RETURN
WRITE.REDO.FILE:
*--------------
    IF NOT(FX.HIST.ERR) THEN
        WRITE "REC" TO F.REDO.FX.HIST.LIST,Y.FOREX.ID ON ERROR

            Y.ERR.MSG = "Unable to Write '":Y.FOREX.ID:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
RETURN
GET.FX.ID.HIST:
*-------------
    Y.FX.LIVE.ID = FIELD(Y.FX.ID,";",1,1)
    Y.CURR.NO = '5'
    Y.FLAG = "" ; Y.DEC.FLAG = ""
    LOOP
    WHILE Y.FLAG NE "Y"
        Y.FOREX.ID = ''
        Y.FOREX.ID = Y.FX.LIVE.ID:";":Y.CURR.NO
        CALL F.READ(FN.FX.HIST,Y.FOREX.ID,R.FX.HIST,F.FX.HIST,FX.HIST.ERR)
        IF R.FX.HIST THEN
            GOSUB INC.CHK.FX
        END ELSE
            IF Y.LATEST.FX.ID THEN
                Y.FLAG = "Y"
            END ELSE
                Y.CURR.NO -= 1
                Y.DEC.FLAG = "Y"
            END
        END
    REPEAT
RETURN
INC.CHK.FX:
*----------
    IF R.FX.HIST<FX.CURRENCY.SOLD> EQ LCCY THEN
        Y.FLAG = "Y"    ;* no need to process this FX id as CURRENCY.SOLD NE LCCY (DOP)
        FX.HIST.ERR = "ERR"
    END ELSE
        Y.LATEST.FX.ID = Y.FOREX.ID
        IF NOT(Y.DEC.FLAG) THEN
            Y.CURR.NO += 1
        END ELSE
            Y.FLAG = "Y"
        END
    END
RETURN
*
RAISE.ERR.C.22:
*--------------
*Handling error process
    MON.TP    = "Reg21"
    REC.CON   = "N21-":Y.FX.ID.LAT:FX.HIST.ERR
    DESC      = "N21-":Y.FX.ID.LAT:FX.HIST.ERR
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
<<<<<<< Updated upstream
*    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
RETURN
END
