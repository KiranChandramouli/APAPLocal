* @ValidationCode : MjotMTI1MDE3ODM3NzpDcDEyNTI6MTY5MDE3NjEyMTM4MjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:52:01
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.PUNISHED.UPLOAD
    
*--------------------------------------------------------------------------
* Developer    : Mauricio Sthandier (msthandier@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP).
* Date         : 01.01.2015
* Description  : Routine for uploading flat file of Punished Loans
* Type         : Batch Routine
* Attached to  : BATCH > BNK/REDO.VP.PUNISHED.UPLOAD
* Dependencies : NA
*--------------------------------------------------------------------------
* Modification History:
* Version   Date           Who            Reference         Description
* 1.0       01.06.2015     msthandier     -                 Initial Version
*           13/07/2023	   CONVERSION TOOL                 AUTO R22 CODE CONVERSION-VM TO @VM,FM TO @FM,++ TO +=1
*           13/07/2023	   VIGNESHWARI                     MANUAL R22 CODE CONVERSION-CALL ROUTINE IS MODIFIED
*--------------------------------------------------------------------------

* <region name="INSERTS">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DM.SERVICE.CONTROL
    $INSERT I_F.DM.MAPPING.DEFINITION
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VP.PUNISHED.UPLOAD
    $USING APAP.REDOSRTN

* Incoming file mapping
* PRODUCT   ;  1
* CUSTOMER  ;  2
* EFF.DATE  ;  3
* CRED.LIMIT  ;  4
* PUNISH.DATE  ;  5
* CARD.NO   ; 6
* BRANCH   ; 7
* CURRENT.CAP  ;  8
* CURRENT.INT  ;  9
* DUE.CAP   ; 10
* DUE.INT   ; 11
* DEBT.INT  ; 12
* TOTAL.BAL  ; 13

* </region>

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
    IF DCOUNT(LOG.MESSAGE,@FM) EQ 0 THEN
        GOSUB POST.OFS
    END
    GOSUB CLOSE.LOG

RETURN

* <region name="GOSUBS" description="Gosub blocks">
**********************
* Initialize variables
INIT:
**********************
* Log writing: process started
    APAP.REDOSRTN.redoSNotifyInterfaceAct ('VPL009', 'BATCH', '06', 'EMAIL TARJETAS CASTIGADAS', 'INICIO - CARGA TARJETAS CASTIGADAS A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '');*MANUAL R22 CODE CONVERSION

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM = ''

    FN.DM.SERVICE.CONTROL = 'F.DM.SERVICE.CONTROL'
    F.DM.SERVICE.CONTROL = ''

    FN.DM.MAPPING.DEFINITION = 'F.DM.MAPPING.DEFINITION'
    F.DM.MAPPING.DEFINITION = ''

    FN.REDO.VP.PUNISHED.UPLOAD = 'F.REDO.VP.PUNISHED.UPLOAD'
    F.REDO.VP.PUNISHED.UPLOAD = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'
    DM.SERVICE.CONTROL.ID = 'TEST.VISION'

    PD.SEP       = ';'
    Y.LOG.IND    = ''
    FILE.OPENED  = 0
    READ.FILE    = 0
    Y.LIN.IN     = 0
    LOG.MESSAGE  = ''

RETURN

************
* Open Files
OPEN.FILES:
************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.DM.SERVICE.CONTROL,F.DM.SERVICE.CONTROL)
    CALL OPF(FN.DM.MAPPING.DEFINITION,F.DM.MAPPING.DEFINITION)
    CALL OPF(FN.REDO.VP.PUNISHED.UPLOAD,F.REDO.VP.PUNISHED.UPLOAD)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

**************
* Main Process
PROCESS:
**************

    CALL OCOMO("Punished loan file process begins....")
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.RVPP, Y.ERR)
    PROCESS.DATE = TRIM(R.RVPP<VP.PARAM.PROCESS.DATE>,' ','B')

* Open Punished Loan file for reading
    PD.PATH = TRIM(R.RVPP<VP.PARAM.PD.FILE.PATH>,' ','B')
    PD.FILE = TRIM(R.RVPP<VP.PARAM.PD.FILE.NAME>,' ','B')
    PD.FILE = EREPLACE(PD.FILE,"<YYYYMMDD>", TODAY)
    DM.PARAMS     = ""
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.1>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.2>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.3>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.4>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.5>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.6>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.7>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.8>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.9>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.10>
    DM.PARAMS<-1> = R.RVPP<VP.PARAM.DM.PARAM.11>

* Open DM mapping for delimiter and OFS.SOURCE retrieval
    CALL CACHE.READ(FN.DM.MAPPING.DEFINITION, DM.SERVICE.CONTROL.ID, R.DMD, Y.DMD.ERR)
    DM.SEP = R.DMD<DM.MD.FM.DELIM>
    OFS.SOUR.ID = R.DMD<DM.MD.OFS.SOURCE>

* Open DM file for writing
    CALL CACHE.READ(FN.DM.SERVICE.CONTROL, DM.SERVICE.CONTROL.ID, R.DSC, Y.DSC.ERR)
    DM.PATH.NAME = R.DSC<DMS.CONTROL.FLAT.FILE.DIR>
    DM.FLAT.FILE = R.DSC<DMS.CONTROL.FLAT.FILE.NAME>
    DM.FILE.NAME = DM.PATH.NAME : '/' : DM.FLAT.FILE
    DELETESEQ DM.FILE.NAME ELSE
*LOG.MESSAGE<-1> = 'ERROR: No se puede habilitar para escritura: ' : DM.FILE.NAME ;* because of this log, ofs message.not posted.
    END
    OPENSEQ DM.FILE.NAME TO DM.FILE ELSE
        NULL
    END

* Read the input file
    OPENSEQ PD.PATH, PD.FILE TO PD.FILE.POINTER THEN
        GOSUB WRITE.DM.FILE
    END ELSE
        CALL OCOMO("***** Error in opening the Punished loan flat file *****")
        LOG.MESSAGE<-1> = 'ERROR: Archivo no encontrado: ' : PD.FILE
    END

    IF NOT(READ.FILE) THEN
        CALL OCOMO("***** Error in reading the Punished loan flat file *****")
        LOG.MESSAGE<-1> = 'ERROR: No se puede leer el archivo: ' : PD.FILE : ' o esta vacio'
    END

    IF FILE.OPENED THEN
* Close input file
        CLOSESEQ PD.FILE.POINTER
* Need to move the processed file into the temp folder.
        Y.MK.CMD = "mkdir ":PD.PATH:"/TEMP"
        EXECUTE Y.MK.CMD
        Y.MV.CMD = "mv ":PD.PATH:"/":PD.FILE:" ":PD.PATH:"/TEMP"
        EXECUTE Y.MV.CMD

    END

RETURN
************************************************************************
WRITE.DM.FILE:
************************************************************************

    Y.DOT = CHARX(13)
    FILE.OPENED = 1
    LOOP
        READSEQ Y.LINE FROM PD.FILE.POINTER THEN
            Y.LIN.IN += 1
            READ.FILE = 1
            CHANGE Y.DOT TO '' IN Y.LINE      ;* To remove the DOT character from text file.

* Obtain Arrangement ID
            Y.ARRANGEMENT.ID = ''
            CALL AA.GET.ARRANGEMENT.ID(Y.ARRANGEMENT.ID)
* Write TAKEOVER activity to data migration file
            Y.AA.ACT.ID = 1
            GOSUB WRITE.ACTIVITY
* Write CAPTURE.BILL activity to data migration file
            Y.AA.ACT.ID = 2
            GOSUB WRITE.ACTIVITY
* Write AMEND.HISTORY activity to data migration file
            Y.AA.ACT.ID = 3
            GOSUB WRITE.ACTIVITY
* Add processed line to report live table
            GOSUB ADD.REPORT
        END ELSE
            EXIT
        END
    REPEAT

RETURN
************************************************************************
* Add the incoming request to REDO.VP.PUNISHED.UPLOAD for report purpose
ADD.REPORT:
************************************************************************
    R.RPU = ''
    R.RPU<PUN.UPL.CARD.NUMBER> = Y.LINE[PD.SEP,6,1]
*CALL F.READ(FN.CUSTOMER,Y.LINE[PD.SEP,2,1],R.C,F.CUSTOMER,Y.C.ERR)
*IF R.C THEN
*R.RPU<PUN.UPL.CLIENT.NAME> = R.C<EB.CUS.SHORT.NAME>
*END ELSE
*R.RPU<PUN.UPL.CLIENT.NAME> = ''
*END
    R.RPU<PUN.UPL.CLIENT.NAME>       = TRIM(Y.LINE[PD.SEP,2,1],"0","L")
    R.RPU<PUN.UPL.EFFECTIVE.DATE>    = Y.LINE[PD.SEP,3,1]
    R.RPU<PUN.UPL.PROCESSING.DATE>   = TODAY
    R.RPU<PUN.UPL.MATURITY.DATE>     = Y.LINE[PD.SEP,5,1]
    R.RPU<PUN.UPL.TOTAL.AMOUNT>      = Y.LINE[PD.SEP,14,1]
    R.RPU<PUN.UPL.ACTIVITY.STATUS>   = ''
    R.RPU<PUN.UPL.OVERALL.STATUS>    = ''
    CALL F.WRITE(FN.REDO.VP.PUNISHED.UPLOAD,Y.ARRANGEMENT.ID,R.RPU)

RETURN

******************************************************************
* Set DM.SERVICE.CONTROL to Verify to pickup newly created DM.FILE
POST.OFS:
******************************************************************
    APPL.NAME = 'DM.SERVICE.CONTROL'
    OFS.FUCN = 'V'
    OFS.OPER = 'PROCESS'
    Y.TXN.ID = 'TEST.VISION'
    Y.VERSION = 'DM.SERVICE.CONTROL,VISION'
    CALL OFS.BUILD.RECORD(APPL.NAME,OFS.FUCN,OFS.OPER,Y.VERSION,'','',Y.TXN.ID,'',OFS.REC)

    OFS.MSG.ID = ''
    OPTIONS = ''
    CALL OFS.POST.MESSAGE(OFS.REC,OFS.MSG.ID,OFS.SOUR.ID,OPTIONS)
    IF NOT(OFS.MSG.ID) THEN
        LOG.MESSAGE<-1> = 'ERROR: No se pudo verificar el registro en DM.SERVICE.CONTROL, no se procesará : ' : DM.FILE
    END

RETURN

***************************
* Close the log and process
CLOSE.LOG:
***************************
    IF DCOUNT(LOG.MESSAGE,@FM) GT 0 THEN
        Y.ERR.LOG = ' [CON ERRORES] '
    END ELSE
        Y.ERR.LOG = ' '
    END

* Generate Log Message
    LOG.FILE.NAME = 'PD' : PROCESS.DATE : '.log'
*CALL REDO.VP.UTIL.LOG(LOG.FILE.NAME, PD.PATH, LOG.MESSAGE) ;* mSth - ToDo

* Log writing: process finished
    APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL009', 'BATCH', '07', 'EMAIL TARJETAS CASTIGADAS', 'FIN' : Y.ERR.LOG : '- CARGA TARJETAS CASTIGADAS A LAS ' : TIMEDATE() : ' - LOG EN ' : PD.PATH, '', '', '', '', '', OPERATOR, '');*MANUAL R22 CODE CONVERSION

RETURN

*********************************
* Write activity upon Y.AA.ACT.ID
WRITE.ACTIVITY:
*********************************
    Y.IDX = 0
    DM.LINE = ''
    GOSUB SET.PARAM   ;* Param1
    GOSUB SET.PARAM   ;* Param2
    GOSUB SET.PARAM   ;* Param3
    GOSUB SET.PARAM   ;* Param4
    GOSUB SET.PARAM   ;* Param5
    GOSUB SET.PARAM   ;* Param6
    GOSUB SET.PARAM   ;* Param7
    GOSUB SET.PARAM   ;* Param8
    GOSUB SET.PARAM   ;* Param9
    GOSUB SET.PARAM   ;* Param10
    GOSUB SET.PARAM   ;* Param11
    WRITESEQ DM.LINE TO DM.FILE ELSE
        LOG.MESSAGE<-1> = 'ERROR: No se pudo escribir linea de origen [' : Y.LIN.IN : '] hacia actividad destino [' : Y.AA.ACT.ID : '] en : ' : DM.FILE
    END

RETURN

*****************************************
* Sets param value as per parametrization
SET.PARAM:
*****************************************
    Y.IDX += 1
* Get activity parameter from multivalue
    Y.VAL = FIELD(DM.PARAMS<Y.IDX>,@VM,Y.AA.ACT.ID)
* Append field separator when string already has first value
    IF DM.LINE THEN
        DM.LINE = DM.LINE : DM.SEP
    END

* If numeral then set Arrangement ID
    IF Y.VAL[1,1] EQ '#' THEN
        DM.LINE := Y.ARRANGEMENT.ID
* Else replace placeholders, or not
    END ELSE
        Y.COUNT = 1
        LOOP
            Y.INDEX = INDEX(Y.VAL,'@',Y.COUNT)
        WHILE Y.INDEX GT 0 DO
            Y.COUNT += 1
            Y.PRE.INDEX = INDEX(Y.VAL,'@',Y.COUNT)
            IF Y.INDEX LT Y.PRE.INDEX THEN
                Y.PIECE = Y.VAL[Y.INDEX,Y.PRE.INDEX - Y.INDEX + 1]

                Y.VALUE  = TRIM(Y.LINE[PD.SEP,Y.PIECE[2,-2],1],"0","L")       ;* Since card & customer no. has prefixed with 0's. it needs to be removed.
                CHANGE Y.PIECE TO Y.VALUE IN Y.VAL
                Y.COUNT = 1
            END
        REPEAT
        DM.LINE := Y.VAL
    END

RETURN
