* @ValidationCode : MjoxNDYxMzEwMTU2OkNwMTI1MjoxNjg1MDEwMTgzODcyOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 May 2023 15:53:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PREVELENCE.STATUS.UPD(ID,R.ACCOUNT,Y.AC.STATUS.POS,Y.STATUS.CHG.UPD,R.AZ.ACCOUNT)
*-------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.PREVALANCE.STATUS
*DESCRIPTION:This routone is used to update the value in ACCOUNT Application besed upon the existing
*status value(L.AC.STATUS1 and L.AC.STATUS2)
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : Y.PGM.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who                 Reference                     Description
*  ------           --------          ---------------                  ------------------
* 11-10-2010     S.Jeyachandran        ODR-2009-08-0490                Initial Creation
* 21-10-2010     S.KAVITHA             ODR-2009-08-0490                Baselined after few logic changes
* 02-05-2011     S.KAVITHA             PACS00055011                    Bug Fixing
* 31-05-2011      RIYAS                PACS00060188                    Bug Fixing
* 19-09-2011      RIYAS                PACS00099905                     Bug Fixing
* 10-01-2012      Prabhu               PACS00172828                     AZ status field updated
* DATE  NAME   REFERENCE    DESCRIPTION
* 31 JAN 2023 Edwin Charles D         ACCOUNTING-CR             TSR479892
* 25-05-2023     Conversion tool        R22 Auto conversion           FM TO @FM, VM to @VM, SM to @SM, ++ to +=, k to K.VAR
* 25-05-2023      Harishvikram C       Manual R22 conversion           CALL routine format modified
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_REDO.B.STATUS1.UPD.COMMON
    $INSERT I_F.REDO.T.STATSEQ.BY.ACCT
    $USING APAP.REDOAPAP
*-------------------------------------------------------------------------------

    FN.REDO.T.STATSEQ.BY.ACCT = 'F.REDO.T.STATSEQ.BY.ACCT'
    F.REDO.T.STATSEQ.BY.ACCT = ''
    CALL OPF(FN.REDO.T.STATSEQ.BY.ACCT, F.REDO.T.STATSEQ.BY.ACCT)

    Y.L.AC.STATUS1.POS=Y.AC.STATUS.POS<1>
    Y.L.AC.STATUS2.POS=Y.AC.STATUS.POS<2>
    GOSUB PROCESS

    Y.FINAL.STATUS = ''; Y.FM.STATUS='';LOOP.SM.CNTR ='' ; LOOP.FM.CNTR = '' ; STAT.FM.CNTR = ''; STAT.SM.CNTR = ''; Y.STATUS =''
RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
*    CALL F.READU(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT,F.ACCOUNT,F.ERR,Y.ERR)
    Y.STATUS.1 = CHANGE(R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS1.POS>,@VM,@FM)
    Y.STATUS2 = CHANGE(R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS2.POS>,@SM,@FM)
    IF Y.STATUS.1 THEN
        Y.STATUS = Y.STATUS.1
    END
    IF Y.STATUS2 THEN
        K.VAR = 1
        Y.NUL.CNT = DCOUNT(Y.STATUS2,@FM)

        LOOP
        WHILE K.VAR LE Y.NUL.CNT
            Y.TMP.STAT = Y.STATUS2<K.VAR>
            IF Y.TMP.STAT THEN
                Y.STATUS.2<-1> = Y.TMP.STAT
            END
            K.VAR += 1
        REPEAT

    END
    Y.STATUS = ''
    Y.AC.TOTAL.STATUS = DCOUNT(Y.STATUS,@FM)
    LOCATE ID IN Y.AC.ARRAY<1> SETTING AC.ID.POS THEN       ;* This is only applicable for L.AC.STATUS1
        Y.STATUS = Y.STATUS.SEQ.ARRAY<AC.ID.POS>
    END

    CALL APAP.REDOAPAP.redoConvMnemToStatus(ID,Y.STATUS)    ;* This is only applicable for L.AC.STATUS2 ;*Manual R22 conversion

    IF Y.STATUS THEN          ;* This is to check the migrated contract.
        Y.AZ.ACCOUNT = ''
        Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
        Y.AZ.ACCOUNT = R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT>

        BEGIN CASE
            CASE Y.AZ.ACCOUNT
                Y.CATEG = 'DEP'

            CASE Y.AC.CATEG GE '6000' AND Y.AC.CATEG LE '6999'
                Y.CATEG = 'SAV'

            CASE Y.AC.CATEG GE '1000' AND Y.AC.CATEG LE '1999'
                Y.CATEG = 'ALL'

        END CASE

        GOSUB FM.COUNTER.CHECK
    END
RETURN
*--------------------------------------------------------------------------------------------
FM.COUNTER.CHECK:
*--------------------------------------------------------------------------------------------
* 20170327 /S TUS
    Y.FINAL.STATUS = '' ; AC.FLAG = '' ; CNT.AC = 1 ; Y.AC.TYPE = ''

    TOT.AC.CNT = DCOUNT(ACCT.TYPE.LIST,@FM)
    LOOP
    WHILE CNT.AC LE TOT.AC.CNT
        Y.AC.TYPE = ACCT.TYPE.LIST<CNT.AC>
        BEGIN CASE
            CASE Y.AC.TYPE EQ Y.CATEG
                GOSUB STATUS.CHECK
            CASE Y.AC.TYPE EQ 'ALL'
                GOSUB STATUS.CHECK
        END CASE

        CNT.AC += 1
    REPEAT

*    IF NOT(Y.FINAL.STATUS) AND NOT(AC.FLAG) THEN  ;* will avoid deleting the existing status from account
*        GOSUB AC.NULL.WRITE
*    END
RETURN

STATUS.CHECK:
*************
    IF Y.STATUS EQ PARAM.STATUS<CNT.AC> THEN
        Y.FINAL.STATUS = PREVALANCE.STATUS<CNT.AC>
        IF R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> NE Y.FINAL.STATUS OR Y.STATUS.CHG.UPD THEN
            GOSUB AC.REC.WRITE.RECORD
            CNT.AC = TOT.AC.CNT+1
            AC.FLAG = '1'
        END

    END
RETURN
*LOCATE Y.STATUS IN PARAM.STATUS SETTING VL.POSN THEN
*Y.FINAL.STATUS = PREVALANCE.STATUS<VL.POSN>
*IF R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> NE Y.FINAL.STATUS OR Y.STATUS.CHG.UPD THEN
*    GOSUB AC.REC.WRITE.RECORD
*END
*END ELSE
*   GOSUB AC.NULL.WRITE
*END
*    RETURN
* 20170327 /E TUS
*----------------------------------------------------------------------------------------------
AC.REC.WRITE.RECORD:
*-----------------------------------------------------------------------------------------------

    R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> = Y.FINAL.STATUS
* CALL F.WRITE(FN.ACCOUNT,Y.PGM.ID,R.ACCOUNT)
    V = AC.AUDIT.DATE.TIME
    CALL F.LIVE.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)
*-    IF R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> THEN
*-        CALL F.READ(FN.AZ.ACCOUNT,ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR)
    IF R.AZ.ACCOUNT THEN
        R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.L.AC.STATUS.POS>=Y.FINAL.STATUS
        V=AZ.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.AZ.ACCOUNT,ID,R.AZ.ACCOUNT)
    END
*-    END
    Y.CURR.NO = R.ACCOUNT<AC.CURR.NO>
    Y.ACT.ID = ID:';':Y.CURR.NO
    R.ACCOUNT.ACT = TODAY
    WRITE R.ACCOUNT.ACT ON F.ACCOUNT.ACT,Y.ACT.ID
RETURN
*----------------------------------------------------------------------------------------------
AC.NULL.WRITE:
*-------------------------------------------------------------------------------------------------
    IF ((R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS>) OR (Y.STATUS.CHG.UPD AND R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS>)) THEN

        R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> = ''
        V = AC.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.ACCOUNT,ID,R.ACCOUNT)
*-        IF R.ACCOUNT<AC.ALL.IN.ONE.PRODUCT> THEN
*-            CALL F.READ(FN.AZ.ACCOUNT,ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,ERR)
        IF R.AZ.ACCOUNT THEN
            R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.L.AC.STATUS.POS>=''
            V=AZ.AUDIT.DATE.TIME
            CALL F.LIVE.WRITE(FN.AZ.ACCOUNT,ID,R.AZ.ACCOUNT)
        END
*-        END
        Y.CURR.NO = R.ACCOUNT<AC.CURR.NO>
        Y.ACT.ID = ID:';':Y.CURR.NO
        R.ACCOUNT.ACT = TODAY
        WRITE R.ACCOUNT.ACT ON F.ACCOUNT.ACT,Y.ACT.ID
    END
RETURN
*-----------------------------------------------------------------------------------------------
PROGRAM.END:
*---------------------------------------------------------------------------------------------------
END
