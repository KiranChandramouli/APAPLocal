*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CLEAR.CHQ.SELECT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CLEAR.CHQ.SELECT
*--------------------------------------------------------------------------------------------------------
*Description  :
*
*Linked With  : Main routine REDO.B.CLEAR.CHQ
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Nov 2010    Mohammed Anies K      ODR-2010-09-0251       Initial Creation
* 07.11.2017    Gopala krishnan R          PACS00633961           MODIFICATION
* 26.03.2018    Gopala Krishnan R          PACS00642346           MODIFICATION
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.BATCH
    $INSERT I_BATCH.FILES
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_REDO.B.CLEAR.CHQ.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    
    LAST.WORK.DAY = R.DATES(EB.DAT.TODAY)
    CALL F.READ(FN.BATCH,BATCH.ID,R.BATCH,FF.BATCH,BATCH.ERR)
    IF R.BATCH THEN
        Y.JOB.LIST = R.BATCH<BAT.JOB.NAME>
        LOCATE Y.JOB.NAME IN Y.JOB.LIST<1,1> SETTING Y.JOB.POS THEN
            Y.BATCH.RUN.DATE = R.BATCH<BAT.LAST.RUN.DATE,Y.JOB.POS>
*PACS00642346 - S
			YTODAY = TODAY
            CALL CDT('',YTODAY,'-1C')
			CALL AWD(Y.REGION,YTODAY,Y.RET.VAL.1)
            IF Y.BATCH.RUN.DATE EQ TODAY THEN
			IF Y.RET.VAL.1 EQ 'W' THEN
                RETURN
            END
			END
*PACS00642346 -E
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
    SEL.CMD = 'SELECT ':FN.REDO.CLEARING.OUTWARD:" WITH CHQ.STATUS EQ 'DEPOSITED' AND EXPOSURE.DATE LE ":LAST.WORK.DAY
    LIST.PARAMETER ="F.SEL.CLEARING.LIST"
    LIST.PARAMETER<1> = ''
    LIST.PARAMETER<3> = SEL.CMD

    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')

*--------------------------------------------------------------------------------------------------------
    RETURN
END
