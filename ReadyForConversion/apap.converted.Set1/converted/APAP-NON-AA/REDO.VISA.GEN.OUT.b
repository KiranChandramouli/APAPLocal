SUBROUTINE  REDO.VISA.GEN.OUT(REC.ID)
**--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.OUT
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --REC.ID--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISA.OUT.MAP
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.VISA.TC40.OUT.FILE
    $INSERT I_F.REDO.VISA.TC52.FILE
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.FEECOLLECT
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
*$INCLUDE TAM.BP I_REDO.VISA.GEN.CHGBCK.OUT.COMMON



    GOSUB PROCESS

RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    OUT.RTN=''
    OUT.USR.DEF.RTN=''
    ACCT.OUT.RTN=''
    Y.STATUS=''
    ERROR.MESSAGE=''
    INS.OTHR.TCR=''
    INS.STATUS=''

    CUR.APP=FIELD(REC.ID,"*",2)
    CUR.ID=FIELD(REC.ID,"*",1)
    Y.VISA.OUT.ID=CUR.ID
    BEGIN CASE

        CASE CUR.APP EQ 'REDO.VISA.OUTGOING'
            CALL F.READ(FN.REDO.VISA.OUTGOING,CUR.ID,R.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING,APP.ERR)
            IF R.REDO.VISA.OUTGOING NE '' THEN
                Y.STATUS =R.REDO.VISA.OUTGOING<VISA.OUT.STATUS>
                TC.CODE=R.REDO.VISA.OUTGOING<VISA.OUT.TRANSACTION.CODE>
                INS.STATUS=VISA.OUT.STATUS
                INS.OTHR.TCR=VISA.OUT.OTHER.TCR.LINE
                Y.APPL=FN.REDO.VISA.OUTGOING
            END
        CASE CUR.APP EQ 'VISA.TC40.OUT.FILE'
            CALL F.READ(FN.VISA.TC40.OUT.FILE,CUR.ID,R.REDO.VISA.OUTGOING,F.VISA.TC40.OUT.FILE,APP.TC40.ERR)
            IF R.REDO.VISA.OUTGOING NE '' THEN
                Y.STATUS =R.REDO.VISA.OUTGOING<VISA.TC40.STATUS>
                Y.FINAL.STATUS =R.REDO.VISA.OUTGOING<VISA.TC40.FINAL.STATUS>
                TC.CODE=R.REDO.VISA.OUTGOING<VISA.TC40.TRANSACTION.CODE>
                INS.STATUS=VISA.TC40.STATUS
                Y.APPL=FN.VISA.TC40.OUT.FILE
            END
        CASE CUR.APP EQ 'REDO.VISA.TC52.FILE'
            CALL F.READ(FN.REDO.VISA.TC52.FILE,CUR.ID,R.REDO.VISA.OUTGOING,F.REDO.VISA.TC52.FILE,APP.TC52.ERR)
            IF R.REDO.VISA.OUTGOING NE '' THEN
                Y.STATUS=R.REDO.VISA.OUTGOING<VSA.TC52.STATUS>
                TC.CODE=R.REDO.VISA.OUTGOING<VSA.TC52.TRANSACTION.CODE>
                INS.STATUS=VSA.TC52.STATUS
                Y.APPL=FN.REDO.VISA.TC52.FILE
            END
        CASE CUR.APP EQ 'REDO.FEECOLLECT'
            CALL F.READ(FN.REDO.FEECOLLECT,CUR.ID,R.REDO.VISA.OUTGOING,F.REDO.FEECOLLECT,FEE.ERR)
            Y.STATUS=R.REDO.VISA.OUTGOING<REDO.FEE.STATUS>
            TC.CODE=R.REDO.VISA.OUTGOING<REDO.FEE.TXN.CODE>
            INS.STATUS=REDO.FEE.STATUS
            Y.APPL=FN.REDO.FEECOLLECT
    END CASE

*IF R.REDO.VISA.OUTGOING NE '' AND  Y.STATUS EQ 'PENDING' THEN
*TC.CODE= R.REDO.VISA.OUTGOING<VISA.OUT.TRANSACTION.CODE>
*END
    IF Y.STATUS NE 'PENDING' THEN
        RETURN
    END

    LOCATE TC.CODE IN R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.TXN.CODE,1> SETTING POS.TC  THEN
        OUT.RTN=R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.PROCESS.RTN,POS.TC>
        OUT.USR.DEF.RTN= R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.USR.DEF.RTN,POS.TC>
        ACCT.OUT.RTN= R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.ACCT.RTN,POS.TC>
    END
    IF OUT.RTN NE '' THEN
        CALL @OUT.RTN(R.REDO.VISA.OUTGOING)
    END

    IF OUT.USR.DEF.RTN NE '' THEN
        CALL @OUT.USR.DEF.RTN
    END

    IF ACCT.OUT.RTN NE '' THEN
        CALL @ACCT.OUT.RTN
    END

    IF CUR.APP EQ 'VISA.TC40.OUT.FILE' THEN
        IF Y.FINAL.STATUS EQ 'REVERSED' THEN
            CALL F.DELETE(Y.APPL,CUR.ID)
        END
    END
    CALL F.DELETE(FN.REDO.VISA.GEN.OUT,REC.ID)
RETURN

END
