* @ValidationCode : MjotMjAwNjI5NzQ4OTpDcDEyNTI6MTY4MzgwOTIwOTA0MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 May 2023 18:16:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.BCR.REPORT.DELIVERY(Y.INT.CODE,Y.INT.TYPE,R.REDO.INTERFACE.PARAM)
*-----------------------------------------------------------------------------
* Esta rutina es la encargada de entregar el archivo generado de acuerdo a los
* datos enviados en el parametro R.REDO.INTERFACE.PARAM. Este par�metro contiene
* la informacion sobre el mecanismo a utilizar para realizar la entrega
* @author mgudino@temenos.com
* @stereotype subroutine
* @package TAM.BP
* @parameters
*                Y.INT.CODE   (in) Current ID
*                Y.INT.TYPE   (in) Is running on BATCH or ONLINE
*                R.REDO.INTERFACE.PARAM (in) Paramters to use
* INPUT / OUTPUT
* ---------------
*               E  (out)    In case of error the message is here
*
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.INTERFACE.SMAIL
    $INSERT I_TAM.EMAIL.COMMON


*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE 2
        Y.FILE.NAME = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>:".":Y.VAR1

        IF Y.VAR1 EQ 2 THEN       ;* Second file may exist in the path depends on condition so we need to check whether file exist in the path then we need to continue.
            F.CHECK.FILE = ''
            OPENSEQ Y.DIR.PATH,Y.FILE.NAME TO F.CHECK.FILE THEN
                CLOSESEQ F.CHECK.FILE
            END ELSE
                Y.VAR1 += 1 ;* R22 Auto conversion
                CONTINUE

            END
        END

        GOSUB PROCESS
        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.SEND.METHOD = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.SEND.METHOD>
    IF Y.SEND.METHOD EQ 'FTP' THEN
        GOSUB PROCESS_FTP
    END ELSE
        GOSUB PROCESS_MAIL
    END
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.SMAIL = 'F.REDO.INTERFACE.SMAIL'
    F.SMAIL = ''
    CALL OPF(FN.SMAIL,F.SMAIL)

* Get from the parameter the ParamType and their ParamValues

    fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

* Get the path where the FILE has to moved in case of success, could be blank
    paramType = 'PATH.SUCCESS'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.PATH.SUCCESS = paramValue

* Get the path where the FILE has to moved in case of failure, could be blank
    paramType = 'PATH.FAILURE'
    GOSUB GET.PARAM.TYPE.VALUE
    Y.PATH.FAILURE = paramValue

    Y.DIR.PATH  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>

RETURN

*** <region name= GET.PARAM.TYPE.VALUE>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
RETURN


*-----------------------------------------------------------------------------
*** </region>

*** <region name= PROCESS_FTP>
*-----------------------------------------------------------------------------
PROCESS_FTP:
*-----------------------------------------------------------------------------

* Get the path where the FTP Listener is "pooling" the files to send
    paramType = 'FTP.LISTENER.PATH'
    GOSUB GET.PARAM.TYPE.VALUE
    IF paramValue EQ '' THEN
        E = Y.ERR
        RETURN
    END
    Y.FTP.LISTENER.PATH = paramValue

* Check if the FTP.LISTENER.PATH exists ?
    CALL BR.CREATE.PATH('CHECK.PATH',Y.FTP.LISTENER.PATH)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END
* Check if the DIR.PATH exists ?
*      Y.DIR.PATH = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>

    CALL BR.CREATE.PATH('CHECK.PATH',Y.DIR.PATH)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END

* Check if the FILE to SEND exists ?
    F.DUMMY.TXT = ''
    OPENSEQ Y.DIR.PATH,Y.FILE.NAME TO F.DUMMY.TXT THEN
        CLOSESEQ F.DUMMY.TXT
    END ELSE
        E = "ST-REDO.BCR.SEQFILE.NOT.EXISTS"
        E<2> = Y.FILE.NAME : @VM : Y.DIR.PATH
        RETURN
    END

* Take the file and copy on FTP.LISTENER
    Y.CMD = "COPY FROM ":Y.DIR.PATH:" TO ":Y.FTP.LISTENER.PATH:" ":Y.FILE.NAME
    Y.ERR.MSG = ''
    GOSUB EXECUTE.COPY
    IF Y.ERR.MSG NE "" THEN
        E = "No se pudo colocar archivo en FTPListener " : Y.ERR.MSG
        RETURN
    END

* Copy the file and moved to PATH.SUCCESS
    IF Y.PATH.SUCCESS EQ '' THEN
        CALL OCOMO("PATH.SUCCESS IS BLANK")
        RETURN
    END

* If the file already exist then to add a random number to the FILE NAME
    Y.FILE.SUCESS = CHANGE(Y.FILE.NAME, ".", "_" : TODAY : ".")
    F.DEST.DUMMY = ''
    OPENSEQ Y.PATH.SUCCESS,Y.FILE.SUCESS TO F.DEST.DUMMY THEN
        CLOSESEQ F.DEST.DUMMY
        Y.DUMMY.ID = 0
        CALL ALLOCATE.UNIQUE.TIME(Y.DUMMY.ID)
        Y.FILE.SUCESS :=  Y.DUMMY.ID
    END

    Y.CMD = ""
    Y.CMD := "COPY FROM ":Y.DIR.PATH:" TO ":Y.PATH.SUCCESS:" "
    Y.CMD := Y.FILE.NAME : "," : Y.FILE.SUCESS
    Y.ERR.MSG = ''
    GOSUB EXECUTE.COPY
    IF Y.ERR.MSG NE "" THEN
        E = Y.ERR.MSG
        RETURN
    END


    Y.PATH.TO.MOVE = Y.PATH.SUCCESS
    GOSUB DELETE.ORIGINAL.FILE


RETURN

*-----------------------------------------------------------------------------
*** </region>

*** <region name= PROCESS_MAIL>
*** Execute the process for sending the file as attachs into a email
*-----------------------------------------------------------------------------
PROCESS_MAIL:
*-----------------------------------------------------------------------------


*  CALL F.READ(FN.SMAIL,'SYSTEM',R.SMAIL,F.SMAIL,Y.ERR) ;*Tus Start
    CALL CACHE.READ(FN.SMAIL,'SYSTEM',R.SMAIL,Y.ERR) ; * Tus End
    IF Y.ERR NE '' THEN
        E = Y.ERR
        RETURN
    END

    fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

    paramType = 'TO'
    GOSUB GET.PARAM.TYPE.VALUE
    IF paramValue EQ '' THEN
        E = Y.ERR
        RETURN
    END
    Y.SMAIL.TO = paramValue

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

    R.EMAIL<E_MAIL.PASSWORD> = R.SMAIL<REDO.INT.SMAIL.PASSWORD>
    R.EMAIL<E_MAIL.FROM> = Y.SMAIL.FROM
    R.EMAIL<E_MAIL.TO> = Y.SMAIL.TO
    R.EMAIL<E_MAIL.TYPE> = "His"
    R.EMAIL<E_MAIL.SUBJECT> = "Buro de Credito ":R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.NAME>
    R.EMAIL<E_MAIL.BODY> = "ADJUNTO INFORMACION BURO DE CREDITO."
    IF Y.SMAIL.CC NE "" THEN
        R.EMAIL<E_MAIL.CC> = Y.SMAIL.CC
    END

    R.EMAIL<E_MAIL.ATTACHMENT> = Y.DIR.PATH:'/':Y.FILE.NAME

*<< Check if the FILE to move exists ?
    F.DUMMY.TXT.1 = ''
    OPENSEQ Y.DIR.PATH, Y.FILE.NAME TO F.DUMMY.TXT.1 THEN
        CLOSESEQ F.DUMMY.TXT.1
    END ELSE
        E    = "ST-REDO.BCR.SEQFILE.NOT.EXISTS"
        E<2> = Y.FILE.NAME : @VM : Y.DIR.PATH
        RETURN
    END
    IF F.DUMMY.TXT.1 NE '' THEN
    END
* >>

    Y.PATH.TO.MOVE = Y.PATH.SUCCESS

*CALL APAP.TAM.TAM.EMAIL.SEND.R(R.EMAIL, Y.ERROR) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.tamEmailSendR(R.EMAIL, Y.ERROR) ;*MANUAL R22 CODE CONVERSION
    IF Y.ERROR NE '' THEN
        E = Y.ERROR
        Y.PATH.TO.MOVE = Y.PATH.FAILURE
    END

* If the file already exist then to add a random number to the FILE NAME
    Y.FILE.SUCESS = CHANGE(Y.FILE.NAME, ".", "_" : TODAY : ".")
    F.DEST.DUMMY.1  = ''
    Y.DUMMY.ID = 0
    OPENSEQ Y.PATH.TO.MOVE,Y.FILE.SUCESS TO F.DEST.DUMMY.1 THEN
        CLOSESEQ F.DEST.DUMMY.1
        CALL ALLOCATE.UNIQUE.TIME(Y.DUMMY.ID)
        Y.FILE.SUCESS :=  Y.DUMMY.ID
    END


* Copy the file and moved to PATH.SUCCESS or PATH.FAILURE
    Y.CMD = ""
    Y.CMD := "COPY FROM ":Y.DIR.PATH:" TO ":Y.PATH.TO.MOVE:" "
*      Y.FILE.MOVE = CHANGE(Y.FILE.NAME, ".", "_" : TODAY : ".")
    Y.CMD := Y.FILE.NAME : "," : Y.FILE.SUCESS

*      E = '' ;* don't do this, because we can lost the real problem when the mail was tried to be sent

*<< Anyway, try to move the file from current directory to failure.path
    Y.ERR.MSG = ''
    GOSUB EXECUTE.COPY
    IF Y.ERR.MSG NE "" THEN
        IF E EQ '' THEN ;* Don't overwrite the current error
            E = Y.ERR.MSG
        END
    END

    GOSUB DELETE.ORIGINAL.FILE

*>>

RETURN

*-----------------------------------------------------------------------------
*** </region>


*** <region name= EXECUTE.COPY>
*** Y.CMD   (in)     Line to Execute
*** E       (out)    blank then process was Ok, otherwise an error occured
*** Execute the process for sending the file as attachs into a email
*-----------------------------------------------------------------------------
EXECUTE.COPY:
*-----------------------------------------------------------------------------
    Y.ERR.MSG = ""
    EXECUTE Y.CMD RETURNING Y.RET CAPTURING Y.CAP
*<< What comes into Y.RET ?
* BROWSER COPY_TO]COPY_TO^805]1]COPY_DONE
* CLASSIC 805]1]COPY_DONE
*>>

    Y.RES.POS = 1
* If the call was done from Browser the answer comes into 2 position
    IF OFS$BROWSER EQ 1 THEN
        Y.RES.POS = 2
    END
    IF Y.RET<Y.RES.POS,2> NE 1 THEN
        Y.ERR.MSG = Y.CAP         ;* Error capture from COPY command
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
*** </region>
*** <region name= DELETE.ORIGINAL.FILE>
*** Delete the file from CURRENT, after the delivery was done
*-----------------------------------------------------------------------------
DELETE.ORIGINAL.FILE:
*-----------------------------------------------------------------------------
    Y.FILE.TO.DELETE = Y.DIR.PATH : "/" : Y.FILE.NAME
    GOSUB DELETE.FILE
    TEXT    = "File & was moved to &"
    TEXT<2> = Y.FILE.NAME : @VM : Y.PATH.TO.MOVE
    CALL OVE
RETURN
*-----------------------------------------------------------------------------
*** </region>
*** <region name= DELETE.FILE.>
*** Delete the file from CURRENT, after the delivery was done
*-----------------------------------------------------------------------------
DELETE.FILE:
*-----------------------------------------------------------------------------

    DELETESEQ Y.FILE.TO.DELETE SETTING yDeleteRet ELSE
        CALL OCOMO("FILE " : Y.FILE.TO.DELETE : " COULD BE DELETED")
    END

RETURN
*-----------------------------------------------------------------------------
*** </region>
END
