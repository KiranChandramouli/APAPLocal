* @ValidationCode : MjotMTAwNTYwNTcxNTpDcDEyNTI6MTcwMzY4MTAyMDA4NTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:13:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
*-----------------------------------------------------------------------------
* <Rating>74</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUT.CHK.LCK.EVNTS
*--------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RAJA SAKTHIVEL K P
* PROGRAM NAME : REDO.V.AUT.CHK.LCK.EVNTS
*--------------------------------------------------------------------------------------------
* DATE        : 26-02-2011
* ISSUE NO    : HD1102525
* MODIFIED BY : SUDHARSANAN S
* Description : This is the authorisation routine for the version to be used for AC.LOCKED.EVENTS
* which is used to update the local field L.AC.STATUS2 of account table based on the value given in AC.LOCKED.EVENTS file (HD1102525)
*------------------------------------------------------------------
* Linked with : Version.control of AC.LOCKED.EVENTS as authorisation routine
* In parameters : None
* Out parameters : None
*------------------------------------------------------------------
* Date            who            ref                desc
* 15 JUN 2011    Prabhu N    PACS00071064          routine modified  to support reversal
* 05 JAN 2011    Prabhu      PACS00172828          Routine modified  to support AZ account field
* 05 MAR 2011    Prabhu      B88 PERFORMANCE ISSUE  SELECT REMOVED FROM ROUTINE AND  CONCAT FILE REDO.ACCT.ALE Used
* 28 MAR 2023    Rajasoundarya S 		TSR-437696			Wrong relation in Consolidation key related to COLLATERAL
* 30 MAY 2023    jayasurya   TSR-574122            Accounting CR
* 30 MAY 2023    EDWIN CDB   TSR-637100           Accounting CR
* 19 OCT 2023  VICTORIA S             MANUAL CONVERSION          FM TO @FM,VM TO @VM, SM TO @SM,CALL ROUTINE MODIFIED
* 28-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.EB.LOOKUP  ;*TSR637100
    $USING APAP.REDOAPAP
    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB UPDATE
RETURN
*******************
INITIALISE:
********************
*initialize variables------
    Y.ACCT.NO = ''
    Y.LOCK.AMT = ''
    Y.AZ.CUR.STAT = ''        ;* PACS00307565 - S/E
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT =''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.REDO.ACCT.ALE='F.REDO.ACCT.ALE'
    F.REDO.ACCT.ALE =''
    CALL OPF(FN.REDO.ACCT.ALE,F.REDO.ACCT.ALE)
	
*TSR-437696
	FN.EB.LOOKUP = 'F.EB.LOOKUP'
	F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)  ;*TSR637100

RETURN
*************
PROCESS:
********************
*-----------------------------------------
* reading the account number and locked amount
*-----------------------------------------

    Y.ACCT.NO = R.NEW(AC.LCK.ACCOUNT.NUMBER)
    Y.LOCK.AMT = R.NEW(AC.LCK.LOCKED.AMOUNT)
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
*HD1102515 - S
    LOC.REF.APP = 'ACCOUNT':@FM:'AC.LOCKED.EVENTS':@FM:'AZ.ACCOUNT' ;*R22 MANUAL CONVERSION
    LOC.REF.FIELD = 'L.AC.STATUS2':@VM:'L.AC.STATUS1':@VM:'L.AC.AV.BAL':@VM:'L.AC.STATUS':@FM:'L.AC.STATUS2':@VM:'L.AC.STATUS1':@FM:'L.AC.STATUS2':@VM:'L.AC.STATUS'   ;* PACS00307565 - S/E ;*R22 MANUAL CONVERSION
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    ACC.POS = LOC.REF.POS<1,1>
    ACC.LOCK.POS = LOC.REF.POS<2,1>
    Y.AVAIL.POS=LOC.REF.POS<1,3>
    Y.ACC.STATUS.POS =LOC.REF.POS<1,4>
    Y.ACC.STATUS1.POS=LOC.REF.POS<1,2>
    Y.ALE.STATUS1.POS=LOC.REF.POS<2,2>
    Y.AZ.STATUS2.POS =LOC.REF.POS<3,1>
* PACS00307565 - S
    Y.AZ.STATUS.POS  =LOC.REF.POS<3,2>
    Y.AZ.STAT.PG     ="PG"
    Y.AC.STAT.PG     ="PG"
* PACS00307565 - E
    R.NEW(AC.LCK.LOCAL.REF)<1,Y.ALE.STATUS1.POS>=R.ACCOUNT<AC.LOCAL.REF,Y.ACC.STATUS1.POS>
    Y.ACCOUNT.STATUS2=R.ACCOUNT<AC.LOCAL.REF,ACC.POS>
    CHANGE @SM TO @FM IN Y.ACCOUNT.STATUS2 ;*R22 MANUAL CONVERSION
    Y.ACCOUNT.STATUS2.CNT=DCOUNT(Y.ACCOUNT.STATUS2,@FM) ;*R22 MANUAL CONVERSION
    Y.ACC.LOCK.STATUS2 = R.NEW(AC.LCK.LOCAL.REF)<1,ACC.LOCK.POS>
    GOSUB UPDATE.STATUS
RETURN

*-------------
UPDATE.STATUS:
*-------------
*-----------------------------------------
* Updating the local field status
*-----------------------------------------
*Prabhu -Start -PACS00071064----------------------------------------------------------------------------------
    IF (V$FUNCTION EQ 'R') OR (R.NEW(AC.LCK.RECORD.STATUS) EQ 'RNAU') THEN
        LOCATE Y.ACC.LOCK.STATUS2 IN Y.ACCOUNT.STATUS2 SETTING POS THEN
*------B88 PERFORMANCE ISSUE-----------------------------------------------------START-------------------------------------------------
*            SEL.CMD  = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ  " : Y.ACCT.NO :" AND L.AC.STATUS2 EQ " : Y.ACC.LOCK.STATUS2
*            CALL EB.READLIST(SEL.CMD,Y.ALE.ID,'',NO.OF.RECORDS,RET.CODE)
            IF Y.ACC.LOCK.STATUS2 THEN
                Y.ACCT.ALE.ID = Y.ACCT.NO :'*':Y.ACC.LOCK.STATUS2
*
*CALL F.READ(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE,F.REDO.ACCT.ALE,ERR)
                CALL F.READU(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE,F.REDO.ACCT.ALE,ERR,'');*R22 MANUAL CODE CONVERSION
                NO.OF.RECORDS=DCOUNT(R.ACCT.ALE,@FM) ;*R22 MANUAL CONVERSION
*

                IF NO.OF.RECORDS EQ '1' THEN
                    Y.STATUS2=Y.ACCOUNT.STATUS2
                    DEL Y.STATUS2<POS>
                    CHANGE @FM TO @SM IN Y.STATUS2 ;*R22 MANUAL CONVERSION
                    R.ACCOUNT<AC.LOCAL.REF,ACC.POS>=Y.STATUS2
****Local Date table and Account status sequence table update ***
*CALL REDO.UPD.ACCOUNT.STATUS.DATE(Y.ACCT.NO,Y.STATUS2)
*R22 MANUAL CONVERSION
                    APAP.REDOAPAP.redoUpdAccountStatusDate(Y.ACCT.NO,Y.STATUS2)
****END****
                    GOSUB UPDATE
                    CALL F.DELETE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID)
                END
                ELSE
                    LOCATE ID.NEW IN R.ACCT.ALE SETTING ACCT.ALE.POS THEN
                        DEL R.ACCT.ALE<ACCT.ALE.POS>
                        CALL F.WRITE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE)
                    END
                END
            END
*----B88 PERFORMANCE ISSUE-E---------------------------------------------------------------------------------------------------------------
        END
    END
*E-------------------------------------------------------------------------------------------------------------
    ELSE
        GOSUB UPDATE.INPUT.STATUS
    END
RETURN
*-------------------
UPDATE.INPUT.STATUS:
*-------------------
    IF  NOT(Y.ACC.LOCK.STATUS2) THEN
        RETURN
    END
    LOCATE Y.ACC.LOCK.STATUS2 IN Y.ACCOUNT.STATUS2 SETTING POS THEN
*Y.LAST.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,ACC.POS,Y.ACCOUNT.STATUS2.CNT> ; If the existing status is again update kindly use this logic
*IF Y.ACC.LOCK.STATUS2 EQ Y.LAST.STATUS.2 ELSE
* R.ACCOUNT<AC.LOCAL.REF,ACC.POS,Y.ACCOUNT.STATUS2.CNT+1> = Y.ACC.LOCK.STATUS2
* GOSUB UPDATE
* END
    END ELSE
        R.ACCOUNT<AC.LOCAL.REF,ACC.POS,Y.ACCOUNT.STATUS2.CNT+1> = Y.ACC.LOCK.STATUS2
****Local Date table and Account status sequence table update ***
*CALL REDO.UPD.ACCOUNT.STATUS.DATE(Y.ACCT.NO,Y.ACC.LOCK.STATUS2)
*R22 MANUAL CONVERSION
        APAP.REDOAPAP.redoUpdAccountStatusDate(Y.ACCT.NO,Y.ACC.LOCK.STATUS2)
****END****
        GOSUB UPDATE
    END
    GOSUB UPDATE.ALE
RETURN

*------------
UPDATE.ALE:
*------------
*--------B88 PERFORMANCE ISSUE---------START----------------------------------------------
    IF Y.ACC.LOCK.STATUS2 THEN
        Y.ACCT.ALE.ID = Y.ACCT.NO :'*':Y.ACC.LOCK.STATUS2
*  CALL F.READ(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE,F.REDO.ACCT.ALE,ERR)
        CALL F.READU(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE,F.REDO.ACCT.ALE,ERR,'');*R22 MANUAL CODE CONVERSION
        LOCATE ID.NEW IN R.ACCT.ALE SETTING Y.ACCT.ALE.POS ELSE
            R.ACCT.ALE<-1>=ID.NEW
            CALL F.WRITE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.ACCT.ALE)
        END
    END
*--------B88 PERFORMANCE ISSUE ---------END-----------------------------------------------

RETURN
********
UPDATE:
********
*-------------------------
*Updating the audit fields
*-------------------------

*CALL F.READ(FN.AZ.ACCOUNT,Y.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR)
    CALL F.READU(FN.AZ.ACCOUNT,Y.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR,'');*R22 MANUAL CODE CONVERSION
    IF R.AZ.ACCOUNT THEN
        Y.INT.LIQ.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
        R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.STATUS2.POS>=R.ACCOUNT<AC.LOCAL.REF,ACC.POS>
* PACS00307565 - S
        Y.AZ.AC.ST2   = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.STATUS2.POS>
        Y.AZ.CUR.STAT = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.STATUS.POS>
        IF Y.AZ.CUR.STAT EQ "" OR Y.AZ.CUR.STAT EQ "AC" AND V$FUNCTION NE 'R' AND Y.AZ.AC.ST2 NE "" THEN
            R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.STATUS.POS> =Y.AZ.STAT.PG
        END
* PACS00307565 - E
        CALL F.WRITE(FN.AZ.ACCOUNT,Y.ACCT.NO,R.AZ.ACCOUNT)
        GOSUB LIQ.ACCT.UPDATE
    END
    GOSUB AUDIT.DET.UPDATE

RETURN

*****************
AUDIT.DET.UPDATE:
*****************
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    R.ACCOUNT<AC.RECORD.STATUS>=''
    R.ACCOUNT<AC.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):FMT(OCONV(CHECK.DATE,"DD"),"R%2"):TEMPTIME
*    R.ACCOUNT<AC.CURR.NO>=R.ACCOUNT<AC.CURR.NO>+1
    R.ACCOUNT<AC.INPUTTER>=TNO:'_':OPERATOR
    R.ACCOUNT<AC.AUTHORISER>=TNO:'_':OPERATOR
    GOSUB WRITE.ACCT
RETURN

*****************
LIQ.ACCT.UPDATE:
*****************
*TSR-437696
    ACC.CATG.ID = "COLLATERAL.DI*CATG"   ;*TSR637100  start
    R.EB.LOOKUP = ""
    EB.LOOKUP.ERR = ""
    CALL F.READ(FN.EB.LOOKUP,ACC.CATG.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    IF Y.INT.LIQ.ACCT THEN
* CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.LIQ.ACCOUNT,F.ACCOUNT,ER.ACCOUNT)
        CALL F.READU(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.LIQ.ACCOUNT,F.ACCOUNT,ER.ACCOUNT,'');*R22 MANUAL CODE CONVERSION
        IF R.LIQ.ACCOUNT THEN
            Y.LIQ.CUSTOMER = R.LIQ.ACCOUNT<AC.CUSTOMER>
            LIQ.ACC.CATG = R.LIQ.ACCOUNT<AC.CATEGORY>
            IF Y.LIQ.CUSTOMER AND R.EB.LOOKUP THEN
				ACC.CATG = R.EB.LOOKUP<EB.LU.DATA.VALUE>
				CAT.CNT = DCOUNT(ACC.CATG,@VM) ;*R22 MANUAL CONVERSION
				Y.CNT = "1"
				LOOP
				WHILE Y.CNT LE CAT.CNT
					EB.ACC.CAT = R.EB.LOOKUP<EB.LU.DATA.VALUE,Y.CNT>
					IF LIQ.ACC.CATG EQ EB.ACC.CAT THEN
						R.LIQ.ACCOUNT<AC.LOCAL.REF,ACC.POS> = R.ACCOUNT<AC.LOCAL.REF,ACC.POS>
						CALL F.WRITE(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.LIQ.ACCOUNT)
                    END
                    Y.CNT++
                REPEAT	  ;*TSR637100  end
            END
        END
    END

RETURN
*----------
WRITE.ACCT:
*----------
*    R.ACCOUNT<AC.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
*    R.ACCOUNT<AC.CO.CODE>=ID.COMPANY
*
*   IF V$FUNCTION NE 'R' THEN
*       R.ACCOUNT<AC.LOCAL.REF,Y.ACC.STATUS.POS> = Y.AC.STAT.PG   ; * PACS00633874
*   END
*
    CALL F.WRITE(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT)
RETURN
*HD1102515 - E
*------------------------------------------------------------------------------------------------------------------------------
END
