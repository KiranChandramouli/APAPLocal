SUBROUTINE REDO.B.UPD.USER.LOG (Y.PROTOCOL.ID)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.UPD.USER.LOG
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or not for transaction well before transac
*               This routine has to be attached to versions used in ATM transaction. Application can be FT,AC.LOCK
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 01 NOV  2010     SRIRAMAN.C                                     Initial Creation
* 01 May 2015      Ashokkumar            PACS00310287              Added signon details
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PROTOCOL
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.USER.LOG.COMMON
    $INSERT I_F.REDO.L.USER.LOG
    $INSERT I_F.USER

    R.PROTOCOL = ''; Y.PROTO.ERR = ''; Y.CLIENT.IP = ''; Y.REMARK = ''
    Y.TIME.MSEC = ''; Y.PROCESS.DATE = ''; Y.ID = ''
    CALL F.READ(FN.PROTO,Y.PROTOCOL.ID,R.PROTOCOL,F.PROTO,Y.PROTO.ERR)
    IF R.PROTOCOL THEN
        Y.ID = R.PROTOCOL<EB.PTL.USER>
        Y.PROCESS.DATE = R.PROTOCOL<EB.PTL.PROCESS.DATE>
        Y.TIME.MSEC = R.PROTOCOL<EB.PTL.TIME.MSECS>
        Y.REMARK = R.PROTOCOL<EB.PTL.REMARK>
        Y.CLIENT.IP = R.PROTOCOL<EB.PTL.CLIENT.IP.ADDRESS>
    END
    IF NOT(Y.ID) THEN
        RETURN
    END

    IF Y.PROCESS.DATE EQ '' THEN
        Y.PROCESS.DATE = R.DATES(EB.DAT.TODAY)
    END
    R.USR.LOG = ''; Y.ERR = ''
    CALL F.READU(FN.LOGG,Y.ID,R.USR.LOG,F.LOGG,Y.ERR,'')
    IF R.USR.LOG THEN
        LOGIN.DATE = R.USR.LOG<REDO.PRO.LOGIN.DATE>
        LOCATE Y.PROCESS.DATE IN LOGIN.DATE<1,1> SETTING LOGIN.POS THEN
            LOGIN.CNT = DCOUNT(R.USR.LOG<REDO.PRO.LOGINTIME,LOGIN.POS>,@SM)
            LOGIN.CNT+=1
            R.USR.LOG<REDO.PRO.LOGINTIME,LOGIN.POS,LOGIN.CNT> = Y.TIME.MSEC
            R.USR.LOG<REDO.PRO.REMARK,LOGIN.POS,LOGIN.CNT> = Y.REMARK
            R.USR.LOG<REDO.PRO.CLIENT.IP,LOGIN.POS,LOGIN.CNT> = Y.CLIENT.IP
        END ELSE
            NEW.CNT = DCOUNT(LOGIN.DATE,@VM)
            NEW.CNT+=1
            R.USR.LOG<REDO.PRO.LOGIN.DATE,NEW.CNT> = Y.PROCESS.DATE
            R.USR.LOG<REDO.PRO.LOGINTIME,NEW.CNT,1> = Y.TIME.MSEC
            R.USR.LOG<REDO.PRO.REMARK,NEW.CNT,1> = Y.REMARK
            R.USR.LOG<REDO.PRO.CLIENT.IP,NEW.CNT,1> = Y.CLIENT.IP
        END
    END ELSE
        R.USR.LOG<REDO.PRO.LOGIN.DATE> = Y.PROCESS.DATE
        R.USR.LOG<REDO.PRO.LOGINTIME> = Y.TIME.MSEC
        R.USR.LOG<REDO.PRO.REMARK> = Y.REMARK
        R.USR.LOG<REDO.PRO.CLIENT.IP> = Y.CLIENT.IP
    END
    CALL F.WRITE(FN.LOGG,Y.ID,R.USR.LOG)
RETURN
END
