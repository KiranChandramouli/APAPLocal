* @ValidationCode : MjoxMDk4MTAwNTE6Q3AxMjUyOjE3MDMxNjA0MTM1Njk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Dec 2023 17:36:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
*20/12/2023         Suresh          R22 Manual Conversion   CALL routine modified

*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_F.BATCH ;*R22 Manual Conversion
    $INSERT I_REDO.B.ALE.UPD.CHEQUES.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion

*   CALL F.READ(FN.BATCH,BATCH.ID,R.BATCH,F.BATCH,BATCH.ERR)
    R.BATCH = EB.Service.Batch.Read(BATCH.ID,BATCH.ERR) ;*R22 Manual Conversion
    IF R.BATCH THEN
*    Y.JOB.LIST = R.BATCH<BAT.JOB.NAME>
        Y.JOB.LIST = R.BATCH<EB.Service.Batch.BatJobName> ;*R22 Manual Conversion
        LOCATE Y.JOB.NAME IN Y.JOB.LIST<1,1> SETTING Y.JOB.POS THEN
*       Y.BATCH.RUN.DATE = R.BATCH<BAT.LAST.RUN.DATE,Y.JOB.POS>
            Y.BATCH.RUN.DATE = R.BATCH<EB.Service.Batch.BatLastRunDate,Y.JOB.POS> ;*R22 Manual Conversion
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

*   CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion

RETURN
*------------------------------------------------------------------------------------------
END
