* @ValidationCode : Mjo2OTU3NTIwNTc6Q3AxMjUyOjE2ODExMTE4OTA5MjU6SVRTUzotMTotMTo5NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 95
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ALE.UPD.CHEQUES.SELECT

*****************************************************************************************
*----------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CLEAR.OUT.SELECT
*-----------------------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              REFERENCE            DESCRIPTION
* 23.11.2010        PACS00146120         INITIAL CREATION
* 07.11.2017        PACS00633961         MODIFICATION
* 26.03.2018        PACS00642346         MODIFICATION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_REDO.B.ALE.UPD.CHEQUES.COMMON

    CALL F.READ(FN.BATCH,BATCH.ID,R.BATCH,F.BATCH,BATCH.ERR)
    IF R.BATCH THEN
        Y.JOB.LIST = R.BATCH<BAT.JOB.NAME>
        LOCATE Y.JOB.NAME IN Y.JOB.LIST<1,1> SETTING Y.JOB.POS THEN
            Y.BATCH.RUN.DATE = R.BATCH<BAT.LAST.RUN.DATE,Y.JOB.POS>
*PACS00642346 -S
            YTODAY = TODAY
            CALL CDT('',YTODAY,'-1C')
            CALL AWD(Y.REGION,YTODAY,Y.RET.VAL.1)
            IF Y.BATCH.RUN.DATE EQ TODAY THEN
                IF Y.RET.VAL.1 EQ 'W' THEN
                    RETURN
                END
            END
*PACS00642346 -S
        END
*PACS00633961 - S
        RUN.DATE = OCONV(DATE(),"D-")
        RUN.DATE = RUN.DATE[7,4]:RUN.DATE[1,2]:RUN.DATE[4,2]
        Y.REGION = '' ; Y.RET.VAL = ''
        CALL AWD(Y.REGION,RUN.DATE,Y.RET.VAL)
        IF Y.RET.VAL EQ 'H' THEN
            RETURN
        END
    END
*PACS00633961 - E
    SEL.CMD="SSELECT " : FN.APAP.H.GARNISH.DETAILS :" WITH FIT.AMOUNT.REQ GT 0 AND AMOUNT.LOCKED GT 0"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
*------------------------------------------------------------------------------------------
END
