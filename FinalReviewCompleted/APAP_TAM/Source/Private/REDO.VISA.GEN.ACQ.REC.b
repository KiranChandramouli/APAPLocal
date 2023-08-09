<<<<<<< Updated upstream
* @ValidationCode : MjotNDA5NTk0MTM3OkNwMTI1MjoxNjg4MzE5NDQ5NzUzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jul 2023 23:07:29
=======
* @ValidationCode : MjoyMTQxNDkwMjk0OkNwMTI1MjoxNjg2NjczOTk5MDA1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:03:19
>>>>>>> Stashed changes
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
<<<<<<< Updated upstream
$PACKAGE APAP.TAM
=======
$PACKAGE APAP.AA
>>>>>>> Stashed changes
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE  REDO.VISA.GEN.ACQ.REC(REC.ID)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC
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
* 12-Jun-2023            h                 Manual R22 conversion   Change CALL @VAL.RTN to CALL @VAL.RTN()
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.VISA.GEN.ACQ.REC.COMMON
    $INSERT I_F.REDO.VISA.OUT.MAP
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_BATCH.FILES

    ATM.ID=FIELD(REC.ID,"*",2)
    IF ATM.ID THEN
        GOSUB PROCESS
    END

RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    R.REDO.VISA.OUTGOING=''
    R.ATM.REVERSAL = ''
    CALL F.READ(FN.ATM.REVERSAL,ATM.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERROR)
    Y.FIELD.NAME = R.REDO.VISA.OUT.MAP<V.OUT.MAP.FIELD.NAME>
    CNT.FILD.NAME  = DCOUNT(Y.FIELD.NAME,@VM)

    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE CNT.FILD.NAME
        FIELD.CONST = ''
        FIELD.VALUE = ''

        FIELD.CONST= R.REDO.VISA.OUT.MAP<V.OUT.MAP.CONSTANT,Y.VAR>
        FLD.POS= R.REDO.VISA.OUT.MAP<V.OUT.MAP.FIELD.POS,Y.VAR>
        ATM.FLD.POS= R.REDO.VISA.OUT.MAP<V.OUT.MAP.ATM.REV.POS,Y.VAR>

        IF ATM.FLD.POS NE '' THEN
            FIELD.VALUE=R.ATM.REVERSAL<ATM.FLD.POS>
        END ELSE
            FIELD.VALUE=FIELD.CONST
        END

        VAL.RTN = R.REDO.VISA.OUT.MAP<V.OUT.MAP.VALUE.RTN,Y.VAR>

        IF VAL.RTN NE '' THEN
*           CALL @VAL.RTN
            CALL @VAL.RTN() ;* R22 Manual Conversion -() added
        END

        R.REDO.VISA.OUTGOING<FLD.POS>=FIELD.VALUE

        Y.VAR++
    REPEAT

    R.REDO.VISA.OUTGOING<VISA.OUT.PURCHASE.DATE>=R.ATM.REVERSAL<AT.REV.TRANS.DATE.TIME>[1,4]
    R.REDO.VISA.OUTGOING<VISA.OUT.ACQR.REF.NUM>=FIELD(ATM.ID,".",2)
    R.REDO.VISA.OUTGOING<VISA.OUT.PROCESS.DATE> = TODAY
    R.REDO.VISA.OUTGOING<VISA.OUT.STATUS> ='PENDING'
    GOSUB VISA.NEXT.ID
<<<<<<< Updated upstream
*CALL REDO.VISA.OUTGOING.WRITE(Y.ID,R.REDO.VISA.OUTGOING)
    APAP.TAM.redoVisaOutgoingWrite(Y.ID,R.REDO.VISA.OUTGOING)    ;*R22 Manual Conv
=======
    CALL REDO.VISA.OUTGOING.WRITE(Y.ID,R.REDO.VISA.OUTGOING)
>>>>>>> Stashed changes
    VAR.ID = Y.ID:'*':'REDO.VISA.OUTGOING'
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,VAR.ID,'')
RETURN
*---------------------------------------------------------------------------------------
VISA.NEXT.ID:
*----------------------------------------------------------------------------------------
    Y.ID.COMPANY=ID.COMPANY
    CALL LOAD.COMPANY(Y.ID.COMPANY)
    FULL.FNAME =FN.REDO.VISA.OUTGOING
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST = ''
    ID.NEWLAST=ID.NEW.LAST
    CALL GET.NEXT.ID(ID.NEWLAST,'F')
    ID.NEW.LAST=ID.NEWLAST
    Y.ID= COMI
RETURN
*-----------------------------------------------------------------------------------------------------
END
