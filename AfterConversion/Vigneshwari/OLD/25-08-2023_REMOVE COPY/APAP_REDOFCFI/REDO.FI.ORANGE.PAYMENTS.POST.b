* @ValidationCode : Mjo1MTU1NDE0Njg6Q3AxMjUyOjE2OTI5Mzg5NjI0MDU6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Aug 2023 10:19:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
*-----------------------------------------------------------------------------
* <Rating>-88</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.FI.ORANGE.PAYMENTS.POST
*------------------------------------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            "" ADDED IN LAST FMT ARGUMENT, CALL method format changed
*25-08-2023          VIGNESHWARI S                   MANUAL R22 CODE CONVERSION               PATH IS MODIFIED
******************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_REDO.FI.ORANGE.PYMT.COMMON
    $INSERT I_TAM.EMAIL.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.INTERFACE.SMAIL
    $USING APAP.TAM
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    GOSUB CHECK.PRELIM.SMAIL
    LOOP.CNT  = 1
    MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                GOSUB PROCESS

            CASE LOOP.CNT EQ 2
                GOSUB PROCESS.MAIL

        END CASE
*
        IF W.ERROR THEN
            PROCESS.GOAHEAD = 0
        END
*
        LOOP.CNT +=1
    REPEAT

*
    IF W.ERROR THEN
        CALL TXT(W.ERROR)
    END
*
RETURN
*
*************************************************************************
*
*
* ======
PROCESS:
* ======
*

*
    POS=''
*  LOOP WHILE READNEXT FI.FILE.ID FROM ORANGE.LIST DO
* Tus Start
    LOOP
        REMOVE FI.FILE.ID FROM ORANGE.LIST SETTING POS
    WHILE FI.FILE.ID:POS
* Tus End
        READ R.DATOS FROM DIRECTORY.POINTER,FI.FILE.ID THEN
            IF R.DATOS THEN
                WFILE.LIST <-1> = FI.FILE.ID
                YDATOS     = YDATOS : YFIELD.SEP : R.DATOS
                YFIELD.SEP = @FM ;*MANUAL R22 CONVERSION
            END
        END
    REPEAT
*
    WSORTED.DATA = SORT(YDATOS)
*
    NO.ORANGE = DCOUNT(WSORTED.DATA,@FM) ;*MANUAL R22 CONVERSION
    FOR FL.CONT = 1 TO NO.ORANGE
        W.DATE     = FIELD(WSORTED.DATA<FL.CONT>,"&&",1)
        REG.INFO   = WSORTED.DATA<FL.CONT>[57,11]
        REG.SIGN   = REG.INFO[1,1]
        REG.AMOUNT = REG.INFO[2,10]
        IF PREV.DATE NE W.DATE THEN
            GOSUB DATE.CHANGE
        END
        DATE.COUNT  += 1
        IF REG.SIGN NE "-" THEN
            DATE.AMOUNT += REG.AMOUNT
        END ELSE
            DATE.AMOUNT -= REG.AMOUNT
        END
    NEXT
*
    GOSUB DATE.CHANGE
*
    PREV.DATE  = ""
    H.COUNT    = 0
*
    FOR FL.CONT = 1 TO NO.ORANGE
        W.DATE  = FIELD(WSORTED.DATA<FL.CONT>,"&&",1)
        IF W.DATE NE PREV.DATE THEN
            H.COUNT    += 1
            W.HEADER    = Y.HEADER<H.COUNT>
            PREV.DATE   = FIELD(W.HEADER,"*",1)
            DATE.COUNT  = FIELD(W.HEADER,"*",2)
            DATE.AMOUNT = FIELD(W.HEADER,"*",3)
            W.TIME      = OCONV(TIME(),"MTS")
            CHANGE ":" TO "" IN W.TIME
            REG.HEADER = "01FTDAPAP    " : FMT(DATE.COUNT,"R%7") : FMT(DATE.AMOUNT,"R2%13") : PREV.DATE : W.TIME : TODAY: FMT(" ",'35L') ;*MANUAL R22 CODE CONVERSION
            WRITESEQ REG.HEADER TO YFILE.POINTER ELSE
                W.ERROR = "Error.writing.record.number.&.data-&":@FM:"HEADER":@VM:REG.HEADER ;*MANUAL R22 CONVERSION
            END
        END
        
        R.DATOS = FIELD(WSORTED.DATA<FL.CONT>,"&&",2)
        WRITESEQ R.DATOS TO YFILE.POINTER ELSE
            W.ERROR = "Error.writing.record.number.&.data-&":@FM:FL.CONT:@VM:R.DATOS
        END
    NEXT
*
    WEOFSEQ YFILE.POINTER
    CLOSESEQ YFILE.POINTER
    CLOSE DIRECTORY.POINTER
*
RETURN
*
* ==========
DATE.CHANGE:
* ==========
*
    IF PREV.DATE THEN
        H.COUNT           += 1
        Y.HEADER<H.COUNT>  = PREV.DATE : "*" : DATE.COUNT : "*" : DATE.AMOUNT
    END
    DATE.COUNT  = 0
    DATE.AMOUNT = 0
    PREV.DATE   = W.DATE
*
RETURN
*
* ===========
PROCESS.MAIL:
* ===========
*
    R.EMAIL<E_MAIL.PASSWORD>   = R.SMAIL<REDO.INT.SMAIL.PASSWORD>
    R.EMAIL<E_MAIL.FROM>       = Y.SMAIL.FROM
    R.EMAIL<E_MAIL.TO>         = Y.SMAIL.TO
    R.EMAIL<E_MAIL.TYPE>       = "His"
    R.EMAIL<E_MAIL.SUBJECT>    = "Archivo Pago Estafeta Orange ": TODAY : " " : R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.NAME>
    R.EMAIL<E_MAIL.BODY>       = "ADJUNTO Archivo Pago Estafeta Orange " : TODAY
    R.EMAIL<E_MAIL.CC>         = Y.SMAIL.CC
    R.EMAIL<E_MAIL.ATTACHMENT> = FILE.PATH:'\':YFILE.NAME
*
    Y.PATH.TO.MOVE             = Y.PATH.SUCCESS

*APAP.TAM.TAM.EMAIL.SEND.R(R.EMAIL, Y.ERROR)
    APAP.TAM.tamEmailSendR(R.EMAIL, Y.ERROR);* R22 Manual Conversion - CALL method format changed
    

    IF Y.ERROR THEN
        FOR Y.NUM.INTENTOS = 1 TO Y.INTENTOS
* APAP.TAM.TAM.EMAIL.SEND.R(R.EMAIL, Y.ERROR)
            APAP.TAM.tamEmailSendR(R.EMAIL, Y.ERROR);* R22 Manual Conversion - CALL method format changed
            IF Y.ERROR THEN
                W.ERROR        = Y.ERROR
                Y.PATH.TO.MOVE = Y.PATH.FAILURE
            END ELSE
                EXIT
            END
        NEXT Y.NUM.INTENTOS 
    END
*
*
*
* If the file already exists, then add a random number to the FILE NAME
*

    Y.FILE.SUCESS = CHANGE(YFILE.NAME, ".", WDATE.STAMP)

    OPENSEQ Y.PATH.TO.MOVE,Y.FILE.SUCESS TO F.DEST.DUMMY.1 THEN
        CLOSESEQ F.DEST.DUMMY.1
        CALL ALLOCATE.UNIQUE.TIME(Y.DUMMY.ID)
        Y.FILE.SUCESS :=  Y.DUMMY.ID
    END


* Copy the file and move to PATH.SUCCESS or PATH.FAILURE
*
*    Y.CMD  = "COPY FROM ":FILE.PATH:" TO ":Y.PATH.TO.MOVE:" "
*    
*    Y.CMD := YFILE.NAME : "," : Y.FILE.SUCESS
    Y.CMD = 'SH -c cp ':FILE.PATH: '/':YFILE.NAME:' ':Y.PATH.TO.MOVE:'/':Y.FILE.SUCESS ;*MANUAL R22 CODE CONVERSION-PATH IS MODIFIED
    Y.ERR.MSG = ''
    GOSUB EXECUTE.COPY
    IF Y.ERR.MSG NE "" THEN
        IF W.ERROR EQ '' THEN     ;* Don't overwrite the current error
            W.ERROR = Y.ERR.MSG
        END
    END
*
RETURN
*
* ===========
EXECUTE.COPY:
* ===========
*
    Y.ERR.MSG = ""
    EXECUTE Y.CMD RETURNING Y.RET CAPTURING Y.CAP
    Y.RES.POS = 1
* If the call was done from Browser the answer comes in position 2 of the array
    IF OFS$BROWSER EQ 1 THEN
        Y.RES.POS = 2
    END
    IF Y.RET<Y.RES.POS,2> NE 1 THEN
        Y.ERR.MSG = Y.CAP         ;* Error capture from COPY command
        RETURN
    END
*
RETURN
*
* ===================
DELETE.ORIGINAL.FILE:
* ===================
*
    Y.FILE.TO.DELETE = FILE.PATH : "\" : FI.FILE.ID

    DELETESEQ Y.FILE.TO.DELETE SETTING yDeleteRet ELSE
        CALL OCOMO("FILE " : FI.FILE.ID : " COULD NOT BE DELETED")
        W.ERROR = "File.&.could.not.be.deleted":@FM:FI.FILE.ID ;*MANUAL R22 CONVERSION
    END
*
RETURN


* ===================
GET.PARAM.TYPE.VALUE:
* ===================
*
    valueNo    = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
    LOOP.CNT        = 1
    MAX.LOOPS       = 7
    YFILE.NAME      = PRE.FILE.NAME:".dat"
    WDATE.STAMP     = "_" : TODAY : "."
*
    YDATOS          = ""
    W.ERROR         = ""
    YFIELD.SEP      = ""
    Y.SMAIL.CC      = ""
    F.DEST.DUMMY.1  = ""
    PREV.DATE       = ""
*
    FL.CONT         = 0
    Y.DUMMY.ID      = 0
    Y.INTENTOS      = 0
*
* Get from the parameter the ParamType and their ParamValues
    fieldParamType  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

* Get the path where the FILE has to moved in case of success, could be blank
    paramType = 'PATH.SUCCESS'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.PATH.SUCCESS = paramValue

* Get the path where the FILE has to moved in case of failure, could be blank
    paramType = 'PATH.FAILURE'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.PATH.FAILURE = paramValue

* Get the number of attempts
    paramType = 'INTENTOS'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.INTENTOS = paramValue

    PRE.FILE.NAME = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                OPEN FILE.PATH TO DIRECTORY.POINTER ELSE
                    W.ERROR = "Erroneous.Path.&":@FM:FILE.PATH ;*MANUAL R22 CONVERSION
                END

            CASE LOOP.CNT EQ 2
                SELECT DIRECTORY.POINTER TO ORANGE.LIST

            CASE LOOP.CNT EQ 3
                OPENSEQ FILE.PATH,YFILE.NAME TO YFILE.POINTER ELSE
                    CREATE YFILE.POINTER ELSE
                        W.ERROR = "File.&.could.not.be.created":@FM:YFILE.NAME
                        PROCESS.GOAHEAD = 0
                    END
                END

            CASE LOOP.CNT EQ 4
*      CALL F.READ(FN.SMAIL,'SYSTEM',R.SMAIL,F.SMAIL,W.ERROR) ;*Tus Start
                CALL CACHE.READ(FN.SMAIL,'SYSTEM',R.SMAIL,W.ERROR) ; * Tus End


        END CASE
*
        IF W.ERROR THEN
            PROCESS.GOAHEAD = 0
        END
*
        LOOP.CNT +=1
    REPEAT

*
RETURN
*
* ======================
CHECK.PRELIM.SMAIL:
* ======================
    paramType = 'TO'
    GOSUB GET.PARAM.TYPE.VALUE
    IF paramValue EQ '' THEN
        WERROR = "Param.&.must.have.a.value":@FM:paramType
    END ELSE
        Y.SMAIL.TO = paramValue
    END


    paramType = 'CC'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.SMAIL.CC = paramValue


    paramType = 'FROM'
    GOSUB GET.PARAM.TYPE.VALUE
    IF paramValue EQ '' THEN
        Y.SMAIL.FROM = R.SMAIL<REDO.INT.SMAIL.USERNAME>
    END ELSE
        Y.SMAIL.FROM = paramValue
    END

RETURN


END
