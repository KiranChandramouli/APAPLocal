* @ValidationCode : MjoxNDM1MzI4ODQ2OkNwMTI1MjoxNjgzODY2OTI0NDEyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 May 2023 10:18:44
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
SUBROUTINE REDO.VI.TC15.IN.DUPLICATE
*-----------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VI.TC15.IN.DUPLICATE
*Date              : 23.11.2010


*----------------------------------------------------------------
*Description:
*----------------
*This routine is to represent the charge back raised
*This need to raise an outgoing message with TC.CODE 35,36,37
*-----------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          ++ TO +=, = TO EQ,VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL routine format modified
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.OUTGOING


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------------------------

    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)
    FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING=''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

RETURN


*-----------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------

    R.NEW(VISA.OUT.ITERATION)=R.NEW(VISA.OUT.ITERATION) + 1
    Y.OLD.ID.NEW=ID.NEW

    IF  R.NEW(VISA.OUT.OUTGOING.REF) EQ '' THEN



        MATBUILD R.REDO.OUTGOING FROM R.NEW

        BEGIN CASE
            CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 15
                TC.CODE.ALT=35
            CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 16
                TC.CODE.ALT=36
            CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 17
                TC.CODE.ALT=37
        END CASE
        R.REDO.OUTGOING<VISA.OUT.TRANSACTION.CODE>=TC.CODE.ALT
        R.REDO.OUTGOING<VISA.OUT.FINAL.STATUS>=''
        R.REDO.OUTGOING<VISA.OUT.STATUS>=''
        Y.ID.COMPANY=ID.COMPANY
        CALL LOAD.COMPANY(Y.ID.COMPANY)
        FULL.FNAME = 'F.REDO.VISA.OUTGOING'
        ID.T  = 'A'
        ID.N ='15'
        ID.CONCATFILE = ''
        COMI = ''
        PGM.TYPE = '.IDA'
        ID.NEW = ''
        V$FUNCTION = 'I'
        ID.NEW.LAST=''
        ID.NEWLAST = ID.NEW.LAST
        CALL GET.NEXT.ID(ID.NEWLAST,'F')
        ID.NEW.LAST=ID.NEWLAST
        Y.ID= COMI
        R.REDO.OUTGOING<VISA.OUT.STATUS>='PENDING'

        OTHR.TCR.ARR=R.REDO.OUTGOING<VISA.OUT.OTHER.TCR.LINE>

        Y.OTHR.TCR.ARR.CNT=DCOUNT(OTHR.TCR.ARR,@VM)
        VAR2=1
        LOOP
        WHILE VAR2 LE Y.OTHR.TCR.ARR.CNT
            OTHR.TCR.ARR<1,VAR2>[1,2]=TC.CODE.ALT
            VAR2 += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT

        R.REDO.OUTGOING<VISA.OUT.OTHER.TCR.LINE>=OTHR.TCR.ARR
    END ELSE
        Y.ID=R.NEW(VISA.OUT.OUTGOING.REF)

        CALL F.READ(FN.REDO.VISA.OUTGOING,Y.ID,R.REDO.OUTGOING,F.REDO.VISA.OUTGOING,ERR.OUT)

        R.REDO.OUTGOING<VISA.OUT.STATUS>='PENDING'
    END

*CALL APAP.TAM.REDO.VISA.OUTGOING.WRITE(Y.ID,R.REDO.OUTGOING) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoVisaOutgoingWrite(yId, rArray);*MANUAL R22 CODE CONVERSION
    ID.GEN.OUT=Y.ID:"*REDO.VISA.OUTGOING"
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,ID.GEN.OUT,'')
    R.NEW(VISA.OUT.OUTGOING.REF)=Y.ID
    ID.NEW=Y.OLD.ID.NEW
RETURN
END
