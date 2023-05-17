SUBROUTINE REDO.APAP.PARAM.PURGE.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* LINKED WITH
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* PROGRAM NAME : REDO.APAP.PARAM.PURGE.SELECT
* ODR          : ODR-2011-03-0113
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*14.04.2011       JANANI                   ODR-2011-03-0113       INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.COMMON
    $INSERT I_F.APAP.REDO.PURGE.PARAM
    $INSERT I_BATCH.FILES

    GOSUB PROCESS

RETURN

********
PROCESS:
*********

    IF CONTROL.LIST EQ '' THEN
        Y.APP = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION>
        Y.APP.LOC = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION,Y.DATE.INIT>
        CHANGE @VM TO @FM IN Y.APP
        CHANGE @SM TO @FM IN Y.APP
        CONTROL.LIST = Y.APP
    END

    IF CONTROL.LIST THEN

        LOCATE CONTROL.LIST<1,1> IN Y.APP.LOC<1,1,1> SETTING Y.APP.POS THEN
            Y.PARAM.DATE = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.PURGE.TILL,Y.DATE.INIT>
            T.DATE.TIME = Y.PARAM.DATE[3,6]:"2359"
            FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
            F.APPLICATION = ''
            CALL OPF(FN.APPLICATION,F.APPLICATION)
            SEL.CMD ="SELECT ":FN.APPLICATION:" WITH DATE.TIME LE ":T.DATE.TIME
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
            CALL BATCH.BUILD.LIST('',SEL.LIST)
        END ELSE
            Y.DATE.INIT += 1
            Y.APP.LOC = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.APPLICATION,Y.DATE.INIT>
            LOCATE CONTROL.LIST<1,1> IN Y.APP.LOC<1,1,1> SETTING Y.APP.POS THEN
                Y.PARAM.DATE = R.APAP.REDO.PURGE.PARAM<REDO.PARAM.PURGE.PURGE.TILL,Y.DATE.INIT>
                T.DATE.TIME = Y.PARAM.DATE[3,6]:"2359"
                FN.APPLICATION  = 'F.':CONTROL.LIST<1,1>
                F.APPLICATION = ''
                CALL OPF(FN.APPLICATION,F.APPLICATION)
                SEL.CMD ="SELECT ":FN.APPLICATION:" WITH DATE.TIME LE ":T.DATE.TIME
                CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)
                CALL BATCH.BUILD.LIST('',SEL.LIST)
            END
        END

    END

RETURN

***************************************
END
*---------------------End of Subroutine--------------------------------------------------------------
