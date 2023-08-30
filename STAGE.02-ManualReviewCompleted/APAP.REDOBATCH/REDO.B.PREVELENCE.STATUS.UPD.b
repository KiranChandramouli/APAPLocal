* @ValidationCode : MjotNDYzNzM5MDU5OkNwMTI1MjoxNjgxMjgyODkzODQ1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:31:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND K TO K.VAR
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_REDO.B.STATUS1.UPD.COMMON
*-------------------------------------------------------------------------------
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
    IF Y.STATUS.1 AND Y.STATUS.2 THEN
        Y.STATUS = Y.STATUS.1:@FM:Y.STATUS.2
    END
    Y.STATUS = SORT(Y.STATUS)

    Y.AC.TOTAL.STATUS = DCOUNT(Y.STATUS,@FM)
    Y.STATUS = CHANGE(Y.STATUS,@FM,":")
    GOSUB FM.COUNTER.CHECK
RETURN
*--------------------------------------------------------------------------------------------
FM.COUNTER.CHECK:
*--------------------------------------------------------------------------------------------
* 20170327 /S TUS
    Y.FINAL.STATUS = ''
    LOCATE Y.STATUS IN PARAM.STATUS SETTING VL.POSN THEN
        Y.FINAL.STATUS = PREVALANCE.STATUS<VL.POSN>
        IF R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.STATUS.POS> NE Y.FINAL.STATUS OR Y.STATUS.CHG.UPD THEN
            GOSUB AC.REC.WRITE.RECORD
        END
    END ELSE
        GOSUB AC.NULL.WRITE
    END
RETURN
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
